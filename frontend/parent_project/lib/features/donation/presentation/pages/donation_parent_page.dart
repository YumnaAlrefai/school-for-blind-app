import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/glass_card.dart';
import 'package:parent_project/Widget/build_button.dart';
import 'package:parent_project/Widget/build_text_field.dart';
import 'package:parent_project/Widget/theme_listener.dart';
import '../../data/datasource/donation_remote_datasource.dart';
import '../../data/repositories/donation_repository.dart';
import '../../logic/cubit/donation_cubit.dart';
import '../../logic/cubit/donation_state.dart';
import 'donation_payment_page.dart';

class DonationParentPage extends StatelessWidget {
  const DonationParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DonationCubit(
        DonationRepository(DonationRemoteDataSource()),
      ),
      child: const _DonationParentView(),
    );
  }
}

class _DonationParentView extends StatefulWidget {
  const _DonationParentView();

  @override
  State<_DonationParentView> createState() => _DonationParentViewState();
}

class _DonationParentViewState extends State<_DonationParentView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
  builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
        backgroundColor: AppColors.bgDark,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<DonationCubit, DonationState>(
          listener: (context, state) {
            if (state is DonationCheckoutSuccess) {
            
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<DonationCubit>(),
                    child: DonationPaymentPage(
                      clientSecret: state.clientSecret,
                      paymentIntentId: state.paymentIntentId,
                    ),
                  ),
                ),
              );
            } else if (state is DonationCheckoutFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is DonationCheckoutLoading;

            return Stack(
              children: [
                /*Positioned.fill(
                  child: Image.asset(
                    'assets/images/background_waves.png',
                    fit: BoxFit.cover,
                  ),
                ),*/
                SafeArea(
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15),
                                  child: GlassCard(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 160,
                                        top: 160,
                                        left: 16,
                                        right: 16,
                                      ),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'معلومات التبرع:',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 40,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            BuildTextField(
                                              controller: nameController,
                                              iconPath:
                                                  'assets/icons/account.svg',
                                              hint: 'الاسم (اختياري)',
                                            ),
                                            const SizedBox(height: 20),
                                            BuildTextField(
                                              controller: amountController,
                                              iconPath:
                                                  'assets/icons/money-bill-wave-solid.svg',
                                              hint: 'المبلغ',
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(height: 40),
                                            isLoading
                                                ? CircularProgressIndicator(
                                                    color: AppColors.textPrimary)
                                                : BuildButton(
                                                    label: 'التالي',
                                                    onPressed: () {
                                                      final amount =
                                                          double.tryParse(
                                                        amountController.text
                                                            .trim(),
                                                      );
                                                      if (amount == null ||
                                                          amount <= 0) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'الرجاء إدخال مبلغ صحيح'),
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                      context
                                                          .read<DonationCubit>()
                                                          .startDonation(
                                                            amount: amount,
                                                            name: nameController
                                                                    .text
                                                                    .trim()
                                                                    .isEmpty
                                                                ? null
                                                                : nameController
                                                                    .text
                                                                    .trim(),
                                                          );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        left: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.subdirectory_arrow_left_outlined,
                            color: AppColors.textPrimary,
                            size: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),),
    );
  }
}