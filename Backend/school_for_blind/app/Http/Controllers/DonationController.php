<?php

namespace App\Http\Controllers;

use App\Http\Requests\CheckoutRequest;
use App\Http\Requests\ConfirmpaymentRequest;
use App\Models\Donation;
use App\Models\SchoolTransaction;
use App\Models\SchoolWallet;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Laravel\Cashier\Cashier;
use Stripe\StripeClient;
class DonationController extends Controller
{
 public function checkout(CheckoutRequest $request)
{
    $amount = $request->amount;
    if ($amount < 1) {
            return response()->json([
                'status' => 'error',
                'message' => 'عذراً، الحد الأدنى للتبرع هو 1 يورو.'
            ], 422);
        }
    $amountInCents = $amount * 100;

    try {
$stripe = new StripeClient(config('cashier.secret') ?? env('STRIPE_SECRET'));
        $paymentIntent = $stripe->paymentIntents->create([
            'amount' => $amountInCents,
            'currency' => 'eur',
            'automatic_payment_methods' => [
                'enabled' => true,
            ],
            'description' => 'تبرع لدعم مدرسة المكفوفين ومسيرتها التعليمية',
        ]);

        $user = auth('sanctum')->user();
          $donatableId = null;
            $donatableType = null;
            $donorName = $request->input('donor_name') ?? 'فاعل خير';
        if ($user) {
       $donorName = $user->fullname ?? $user->name;
       $donatableId = $user->id;
       $donatableType = get_class($user);
       if (empty($donorName)) {
                $donorName = 'فاعل خير';
            }
        } 
        if (empty($donorName)) {
            $donorName = 'طالب مسجل';
        }

        DB::table('donations')->insert([
            'amount' => $amount,
            'currency' => 'eur',
            'donor_name' => $donorName,
            'stripe_session_id' => $paymentIntent->id,
            'status' => 'pending',
            'donatable_id' => $donatableId, 
            'donatable_type' => $donatableType,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json([
            'status' => 'success',
            'client_secret' => $paymentIntent->client_secret,
            'payment_intent_id' => $paymentIntent->id,
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => 'فشلت عملية معالجة الدفع: ' . $e->getMessage()
        ], 500);
    }}
public function confirmPayment(ConfirmpaymentRequest $request){
try {
            return DB::transaction(function () use ($request) {

                $donation = DB::table('donations')
                    ->where('stripe_session_id', $request->payment_intent_id)
                    ->lockForUpdate()
                    ->first();

                if (!$donation) {
                    return response()->json(['status' => 'error', 'message' => 'عذراً، عملية التبرع هذه غير موجودة لدينا'], 404);
                }

                if ($donation->status === 'completed') {
                   $wallet = SchoolWallet::getWallet();
                return response()->json([
                        'status' => 'success',
                        'message' => 'هذه العملية تم تأكيدها ومعالجتها مسبقاً!'
                    ], 200);
                }

                DB::table('donations')
                    ->where('stripe_session_id', $request->payment_intent_id)
                    ->update([
                        'status' => 'completed',
                        'updated_at' => now()
                    ]);
                    $wallet = SchoolWallet::getWallet();
                $wallet->balance += $donation->amount;
                $wallet->save();
                SchoolTransaction::create([
                    'type'           => 'deposit',
                    'amount'         => $donation->amount,
                    'description'    => "تبرع ناجح بقلب التطبيق من: {$donation->donor_name} بقيمة: {$donation->amount}",
                    'reference_id'   => $donation->id,
                    'reference_type' => Donation::class,
                ]);

                return response()->json([
                    'status' => 'success',
                    'message' => 'تم تحديث حالة التبرع بنجاح في قاعدة البيانات!'
                ]);
            });
        } catch (\Exception $e) {
            return response()->json([
                'status' => 'error',
                'message' => 'حدث خطأ غير متوقع: ' . $e->getMessage()
            ], 500);
        }
}
public function cancel(Request $request)
    {
        $paymentIntentId = $request->query('payment_intent_id');

        if ($paymentIntentId) {

            $donation = DB::table('donations')
                ->where('stripe_session_id', $paymentIntentId)
                ->first();

            if ($donation) {
                if ($donation->status === 'completed') {
                    return response()->json([
                        'status' => 'error',
                        'message' => 'محاولة محظورة أمنياً: لا يمكن إلغاء أو حذف هذه العملية لأنها مكتملة بالفعل! 🔐'
                    ], 403);
                }

                DB::table('donations')->where('stripe_session_id', $paymentIntentId)->delete();

                return response()->json([
                    'status' => 'cancelled',
                    'message' => 'تم إلغاء عملية التبرع وحذف السجل المؤقت  بنجاح. 🗑️'
                ], 200);
            }
        }

        return response()->json([
            'status' => 'cancelled',
            'message' => 'تم إلغاء العملية'
        ], 200);
    }
}
