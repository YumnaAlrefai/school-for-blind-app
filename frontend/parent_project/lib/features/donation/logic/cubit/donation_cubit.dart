import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../data/repositories/donation_repository.dart';
import 'donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  final DonationRepository repository;

  DonationCubit(this.repository) : super(DonationInitial());

  Future<void> startDonation({required double amount, String? name}) async {
    try {
      emit(DonationCheckoutLoading());
      final result = await repository.checkout(amount: amount, name: name);
      if (!isClosed) {
        emit(DonationCheckoutSuccess(
          result.clientSecret,
          result.paymentIntentId,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DonationCheckoutFailure(e.toString()));
      }
    }
  }

  Future<void> payWithCard({
    required String clientSecret,
    required String paymentIntentId,
    required CardDetails cardDetails,
    String postalCode = '10001',
  }) async {
    try {
      emit(DonationPaymentLoading());

      await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              address: Address(
                postalCode: postalCode,
                country: 'US',
                city: 'Test',
                line1: 'Test',
                line2: '',
                state: '',
              ),
            ),
          ),
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        await _confirmWithBackend(paymentIntentId);
      } else {
        if (!isClosed) {
          emit(DonationPaymentFailure('عملية الدفع غير مكتملة، يرجى المحاولة مجدداً'));
        }
      }
    } on StripeException catch (e) {
      if (!isClosed) {
        emit(DonationPaymentFailure(
          e.error.localizedMessage ?? 'فشلت عملية الدفع، تأكد من بيانات البطاقة',
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DonationPaymentFailure('حدث خطأ غير متوقع أثناء الدفع'));
      }
    }
  }

  Future<void> _confirmWithBackend(String paymentIntentId) async {
    try {
      emit(DonationConfirmLoading());
      final result = await repository.confirm(paymentIntentId);
      if (!isClosed) {
        emit(DonationConfirmSuccess(result.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(DonationConfirmFailure(
          'تم الدفع بنجاح، بس صار خطأ بتحديث الحالة محليًا. رح يتحدث تلقائيًا عبر الـ Webhook.',
        ));
      }
    }
  }
}