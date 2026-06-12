<?php

namespace App\Services;

use App\Models\PointRedemptionRequest;
use App\Models\Student;
use Illuminate\Support\Facades\DB;
use Exception;
use Stripe\Stripe;
use Stripe\Transfer;

class PointRedemptionService
{
    public function getSchoolAvailableBalance(): float
    {
       $totalDonations = DB::table('donations')->where('status', 'completed')->sum('amount');
        $totalPaidOut = DB::table('point_redemption_requests')
            ->where('status', 'approved')
            ->sum('amount_paid');
        return (float) ($totalDonations - $totalPaidOut);
    }
    public function createRequest(Student $student, int $points)
    {
        if ($points <= 0) {
            throw new Exception('عذراً، يجب أن تكون النقاط المستبدلة أكبر من الصفر.');
        }

        if ($student->points < $points) {
            throw new Exception('رصيد نقاطك الحالي غير كافٍ لإتمام هذا الطلب.');
        }

        return PointRedemptionRequest::create([
            'student_id' => $student->id,
            'points_to_redeem' => $points,
            'status' => 'pending',
        ]);
    }
    public function approveRequest(PointRedemptionRequest $request, float $amountToPay)
    {
        if ($request->status !== 'pending') {
            throw new Exception('تمت معالجة هذا الطلب مسبقاً.');
        }

        $student = $request->student; // تأكدي أن العلاقة student معرّفة في موديل PointRedemptionRequest

        // فرضاً أن حقل معرّف ستريب مخزن في جدول الطلاب أو المستخدمين باسم stripe_connect_id
        if (!$student->stripe_connect_id) {
            throw new Exception('عذراً، لا يمكن تحويل الأموال؛ الطالب لم يربط محفظته المالية بـ Stripe Connect بعد.');
        }

        // 2. التحقق من الرصيد المحلي المسجل بالداتابيز أولاً
        $availableBalance = $this->getSchoolAvailableBalance();
        if ($availableBalance < $amountToPay) {
            throw new Exception("رصيد المدرسة الحالي غير كافٍ (محلياً). المتاح: {$availableBalance}، والمطلوب: {$amountToPay}");
        }

        if ($student->points < $request->points_to_redeem) {
            throw new Exception('نقاط الطالب لم تعد كافية لإتمام العملية.');
        }

        // 3. البدء في المعاملة المالية والبرمجية المشتركة
        DB::beginTransaction();
        try {
            // أ) استدعاء Stripe لعمل التحويل الفوري المباشر (Transfer)
            Stripe::setApiKey(config('cashier.secret') ?? env('STRIPE_SECRET'));

            $stripeTransfer = Transfer::create([
                'amount' => $amountToPay * 100, // تحويل المبلغ لسنتات (مثلاً 10 يورو تصبح 1000 سنت)
                'currency' => 'eur', // العملة المتوافقة مع حسابكِ
                'destination' => $student->stripe_connect_id, // معرّف محفظة الطالب acct_xxxx ديناميكياً
                'description' => "استبدال نقاط الطالب المكافئة: {$request->points_to_redeem} نقطة برصيد مالي الكتروني.",
            ]);

            // ب) خصم النقاط محلياً بعد نجاح حركة ستريب
            $student->points = $student->points - $request->points_to_redeem;
            $student->save();

            // ج) تحديث بيانات الطلب وحفظ معرّف التحويل للتوثيق
            $request->status = 'approved';
            $request->amount_paid = $amountToPay;
            // يمكنكِ إضافة حقل stripe_transfer_id في جدول الطلبات كتوثيق للأرشيف إذا أحببتِ
            // $request->stripe_transfer_id = $stripeTransfer->id;
            $request->save();

            DB::commit();
            return $request;

        } catch (Exception $e) {
            DB::rollBack();
            // هنا إذا فشل ستريب (بسبب نقص رصيد حساب المدرسة الحقيقي بالـ Stripe Dashboard)، سيتم إلغاء كل شيء
            throw new Exception('فشلت عملية تحويل الأموال عبر Stripe: ' . $e->getMessage());
        }
    }
    public function rejectRequest(PointRedemptionRequest $request)
    {
        if ($request->status !== 'pending') {
            throw new Exception('تمت معالجة هذا الطلب مسبقاً.');
        }
       try {
            $request->status = 'rejected';
            $request->save();

            return $request;
        } catch (Exception $e) {
            throw new Exception('حدث خطأ أثناء معالجة العملية: ' . $e->getMessage());
        }

    }
}
