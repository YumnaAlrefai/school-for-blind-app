<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Student;
use App\Models\Teacher;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $pendingstudentsCount = Student::where('status', 'pending')->count();
        $pendingteachersCount = Teacher::where('status', 'pending')->count();
        $studentsCount = Student::where('status', 'approved')->count();
        $teachersCount = Teacher::where('status', 'approved')->count();


        return view('dashboard', compact('pendingteachersCount', 'pendingstudentsCount', 'studentsCount', 'teachersCount'));
    }

    public function showRequests($type)
    {
        if (!in_array($type, ['student', 'teacher'])) {
            abort(404);
        }

        if ($type === 'student')
            $requests = Student::where('status', 'pending')->latest()->paginate(10);
        else
            $requests = Teacher::where('status', 'pending')->latest()->paginate(10);


        $title = ($type == 'teacher') ? 'طلبات الأساتذة' : 'طلبات الطلاب';

        return view('pages.requests.index', compact('requests', 'title', 'type'));
    }


    public function getRequestDetails($type, $id)
    {
        try {
            if ($type === 'teacher') {
                $user = Teacher::findOrFail($id);
                $name = $user->full_name;
                $label = 'معلم';
                $viewPath = 'partials.teacher_details';
            } else {
                $user = Student::findOrFail($id);
                $name = $user->fullname;
                $label = 'طالب';
                $viewPath = 'partials.student_details';
            }

            $html = view($viewPath, compact('user'))->render();

            return response()->json([
                'html' => $html,
                'name' => $name,
                'type_label' => $label
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function updateStatus(Request $request, $type, $id)
    {
        $model = ($type === 'teacher') ? Teacher::class : Student::class;

        $user = $model::findOrFail($id);

        $user->status = $request->status;
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث حالة الطلب بنجاح'
        ]);
    }
}
