<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Question;
use App\Models\Quiz;
use App\Models\Lesson;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TeacherTransferController extends Controller
{
    public function transferAssets(Request $request)
    {
        $request->validate([
            'old_teacher_id' => 'required|exists:teachers,id',
            'new_teacher_id' => 'required|exists:teachers,id|different:old_teacher_id',
        ]);

        $oldTeacher = User::findOrFail($request->old_teacher_id);
        $newTeacher = User::findOrFail($request->new_teacher_id);

        DB::beginTransaction();

        try {
            Quiz::where('teacher_id', $oldTeacher->id)
                ->update(['teacher_id' => $newTeacher->id]);

            // Question::where('teacher_id', $oldTeacher->id)
            //     ->update(['teacher_id' => $newTeacher->id]);

            Lesson::where('teacher_id', $oldTeacher->id)
                ->update(['teacher_id' => $newTeacher->id]);

            $oldTeacher->update(['status' => 'Suspended']);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'تم نقل المحتوى التعليمي (الكويزات، بنك الأسئلة، والدروس) إلى الأستاذ البديل بنجاح.',
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'error' => 'حدث خطأ أثناء نقل البيانات، تم التراجع عن العملية للحفاظ على الأرشيف.',
                'details' => $e->getMessage()
            ], 500);
        }
    }
}