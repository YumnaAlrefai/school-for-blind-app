import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

/// شاشة الإبلاغ عن رسالة طالب
class ReportMessageScreen extends StatefulWidget {
  final int messageId;

  const ReportMessageScreen({
    super.key,
    required this.messageId,
  });

  @override
  State<ReportMessageScreen> createState() => _ReportMessageScreenState();
}

class _ReportMessageScreenState extends State<ReportMessageScreen> {
  final TextEditingController _reasonController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      _showSnack('يرجى كتابة سبب الإبلاغ');
      return;
    }

    setState(() => _sending = true);

    final result = await getIt<TeacherRepo>()
        .reportMessage(widget.messageId, {'reason': reason});

    if (!mounted) return;
    setState(() => _sending = false);

    result.when(
      success: (_) {
        _showSnack('تم إرسال البلاغ');
        Navigator.pop(context);
      },
      failure: (_) => _showSnack('تعذّر إرسال البلاغ'),
    );
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(fontSize: 18))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                    color: Colors.white24, thickness: 1, height: 20),
                _buildTopBar(),
                const Divider(
                    color: Colors.white24, thickness: 1, height: 20),
                const SizedBox(height: 40),

                // سبب الإبلاغ
                _buildField(
                  controller: _reasonController,
                  hint: 'سبب الإبلاغ',
                  icon: Icons.help_outline,
                  maxLines: 4,
                ),
                const SizedBox(height: 40),

                Center(
                  child: _sending
                      ? const CircularProgressIndicator(
                          color: AppColors.kPrimaryColor)
                      : _buildSendButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الإبلاغ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: "Arabic Typesetting",
            fontWeight: FontWeight.w300,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.subdirectory_arrow_left,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(icon, color: AppColors.kPrimaryColor, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              maxLines: maxLines,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    const TextStyle(color: Colors.white38, fontSize: 20),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _submit,
      child: Container(
        width: 332,
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.kPrimaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Text(
          'إرسال',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: "Arabic Typesetting",
          ),
        ),
      ),
    );
  }
}