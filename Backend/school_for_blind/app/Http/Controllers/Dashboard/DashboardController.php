<?php

namespace App\Http\Controllers\Dashboard;

use App\Http\Controllers\Controller;
use App\Models\Caregiver;
use App\Models\Classes;
use App\Models\Student;
use App\Models\Teacher;
use App\Services\WhatsAppService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;


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
        $classes = Classes::all();
        return view('pages.requests.index', compact('requests', 'title', 'type', 'classes'));
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
                'type_label' => $label,
                'level' => $user->level
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function updateStatus(Request $request, $type, $id, WhatsAppService $whatsApp)
    {
        $rules = [
            'status' => 'required|in:approved,rejected',
        ];

        if ($request->status === 'approved') {
            if ($type === 'teacher') {
                $rules['class_id'] = 'required|array';
                $rules['class_id.*'] = 'integer|exists:classes,id';
            } else
                $rules['class_id'] = 'required|integer|exists:classes,id';
        }

        $request->validate($rules);

        $model = ($type === 'teacher') ? Teacher::class : Student::class;

        $user = $model::findOrFail($id);
        $user->status = $request->status;

        DB::transaction(function () use ($request, $type, $user, $whatsApp) {
            $user->status = $request->status;
            if ($request->status === 'approved') {
                if ($type === 'student') {
                    $password = Str::lower(Str::random(10));
                    $caregiver = Caregiver::firstOrCreate(
                        ['phone' => $user->parent_phone],
                        ['password' => Hash::make($password)]
                    );
                    $user->parent_id = $caregiver->id;
                    $user->class_id = $request->class_id;
                    $whatsApp->sendStudentinfo($user->phone, $user->fullname, $user->parent_phone, $password);

                } elseif ($type === 'teacher') {
                    $user->classes()->syncWithoutDetaching($request->class_id);
                    $whatsApp->sendTeacherinfo($user->phone, $user->full_name);
                }
            }
            $user->save();
        });

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث حالة الطلب بنجاح'
        ]);
    }
}
