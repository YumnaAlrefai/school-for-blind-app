import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/theme_listener.dart';

import 'package:parent_project/features/auth/data/datasource/support_remote_datasource.dart';
import 'package:parent_project/features/technical_support/data/repositories/support_repository.dart';
import 'package:parent_project/features/technical_support/logic/cubit/support_cubit.dart';
import 'package:parent_project/features/technical_support/logic/cubit/support_state.dart';

class TechnicalSupport extends StatelessWidget {
  const TechnicalSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit(
        SupportRepository(SupportRemoteDataSource()),
      ),
      child: const _TechnicalSupportView(),
    );
  }
}

class _TechnicalSupportView extends StatefulWidget {
  const _TechnicalSupportView();

  @override
  State<_TechnicalSupportView> createState() => _TechnicalSupportViewState();
}

class _TechnicalSupportViewState extends State<_TechnicalSupportView> {
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  File? _selectedImage;
  bool _hasText = false;

  static const Color disabledOlive = Color(0xFF4E5A1E);

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      final hasText = _descriptionController.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _handleSubmit() {
    if (!_hasText) return;

    context.read<SupportCubit>().sendTicket(
          message: _descriptionController.text.trim(),
          image: _selectedImage,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ThemeListener(
  builder: (context) => Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: BlocConsumer<SupportCubit, SupportState>(
            listener: (context, state) {
              if (state is SupportSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.response.message)),
                );
                setState(() {
                  _descriptionController.clear();
                  _selectedImage = null;
                });
              }

              if (state is SupportFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionLabel('صف المشكلة الفنية:'),
                          const SizedBox(height: 10),
                          _buildDescriptionField(),
                          const SizedBox(height: 25),
                          _buildSectionLabel('لقطة شاشة للمشكلة (اختياري):'),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildScreenshotBox(),
                          ),
                          const SizedBox(height: 110),
                          state is SupportLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildSubmitButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: Border(
          bottom: BorderSide(color: AppColors.overlay12, width: 1),
          top: BorderSide(color: AppColors.overlay12, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الدعم الفني',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.subdirectory_arrow_left_outlined,
              color: AppColors.textPrimary,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 32),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return AnimatedBuilder(
      animation: _focusNode,
      builder: (context, child) {
        final bool isFocused = _focusNode.hasFocus;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isFocused
                  ? AppColors.accentGreen
                  : AppColors.fieldBorder,
              width: 1,
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            focusNode: _focusNode,
            maxLines: 4,
            textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 25),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreenshotBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(65, 212, 255, 84),
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_selectedImage!, fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedImage = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Icon(
                Icons.add_photo_alternate_outlined,
                color: AppColors.accentGreen,
                size: 40,
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _hasText ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _hasText ? AppColors.accentGreen : disabledOlive,
          disabledBackgroundColor: disabledOlive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          'إرسال',
          style: TextStyle(
            color: _hasText ? AppColors.bgDark : AppColors.overlay38,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}