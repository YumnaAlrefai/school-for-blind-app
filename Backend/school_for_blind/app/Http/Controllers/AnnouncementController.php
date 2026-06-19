<?php
namespace App\Http\Controllers;

use App\Events\AnnouncementCreated;
use App\Http\Requests\StoreAnnouncementRequest;
use App\Models\Announcement;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function store(StoreAnnouncementRequest $request)
    {
       
        $announcement = Announcement::create([
            'type' =>$request->input('type'),
            'title' => $request->input('title'),
            'content' => $request->input('content'),
            'level'=>$request->input('level'),
            'target_audience'=>$request->input('target_audience'),
        ]);
event(new AnnouncementCreated($announcement));
        /*
        | كود إشعارات الفايربيز

        */

        // try {
        //     $messaging = Firebase::messaging();
        //     $messaging->send([
        //         'topic' => 'all_students',
        //         'notification' => [
        //             'title' => '📢 إعلان جديد من المدرسة',
        //             'body'  => $request->content, // نص الإعلان نفسه
        //         ],
        //     ]);
        // } catch (\Exception $e) {
        //     \Log::error('Firebase Notification Error: ' . $e->getMessage());
        // }

        return response()->json([
            'message' => 'تم نشر الإعلان بنجاح للجميع',
          'data' => [
                'id'         => $announcement->id,
                'type'       => $announcement->type,
                'content'    => $announcement->content,
                'title'      => $announcement->title,
                'created_at' => $announcement->created_at,
                'updated_at' => $announcement->updated_at,
            ]
        ], 201);
    }

   public function index()
{
    $query = Announcement::query();
    if (auth()->guard('student')->check()) {
        $student = auth()->guard('student')->user();
        $query->where('target_audience', 'student')
              ->whereIn('level', [$student->level, 'all']); 

    } elseif (auth()->guard('caregiver')->check()) {
        $caregiver = auth()->guard('caregiver')->user();
        $query->where('target_audience', 'caregiver')
              ->whereIn('level', [$caregiver->level, 'all']); 
              } elseif (auth()->guard('teacher')->check()) {
        $teacher = auth()->guard('teacher')->user();

        $query->where('target_audience', 'teacher')
              ->whereIn('level', [$teacher->level, 'all']);

    } elseif (auth()->guard('admin')->check()) {
        $admin = auth()->guard('admin')->user();
        
        if ($admin->role === 'teacher') {
            $query->where('target_audience', 'teacher')
                  ->whereIn('level', [$admin->level, 'all']);
            }
        
    } else {
        return response()->json(['message' => 'غير مصرح لك برؤية الإعلانات.'], 401);
    }

    $announcements = $query->orderBy('created_at', 'desc')->get();
if ($announcements->isEmpty()) {
    return response()->json([
        'message' => 'لا توجد إعلانات متاحة حالياً.'
    ], 200); 
}
    $processedAnnouncements = $announcements->map(function ($announcement) {
        
      if ($announcement->type === 'exam_schedule') {
        return [
            'id'         => $announcement->id,
            'type'       => $announcement->type,
            'title'      => $announcement->title, 
            'created_at' => $announcement->created_at,
            'updated_at' => $announcement->updated_at,
        ];
    
     } else {
        if (is_string($announcement->content)) {
            $decodedContent = json_decode($announcement->content, true);
            $isJson = (json_last_error() === JSON_ERROR_NONE && is_array($decodedContent));
            $contentData = $isJson ? $decodedContent : $announcement->content;
        } else {
            $contentData = $announcement->content;
        }

        return [
            'id'              => $announcement->id,
            'type'            => $announcement->type,
            'title'           => $announcement->title, 
            'target_audience' => $announcement->target_audience,
            'grade'           => $announcement->grade,
            'content'         => $contentData, 
            'created_at'      => $announcement->created_at,
            'updated_at'      => $announcement->updated_at,
        ];
        }
    });

    return response()->json($processedAnnouncements, 200);
}
  public function showExam($id)
{
        $announcement = Announcement::find($id, ['*']);

    if (!$announcement || $announcement->type !== 'exam_schedule') {
        return response()->json([
            'message' => 'برنامج الامتحان غير موجود أو قد تم حذفه'
        ], 404);
    }

    if (auth()->guard('student')->check()) {
        $student = auth()->guard('student')->user();
        if ($announcement->grade !== $student->grade && $announcement->grade !== 'all') {
            return response()->json(['message' => 'عذراً، هذا البرنامج غير مخصص لصفك.'], 403);
        }
    }

    return response()->json([
        'id'           => $announcement->id,
        'type'         => $announcement->type,
        'title'        => $announcement->title, 
        'exam_program' => $announcement->content, 
        'created_at'   => $announcement->created_at
    ], 200);
}}