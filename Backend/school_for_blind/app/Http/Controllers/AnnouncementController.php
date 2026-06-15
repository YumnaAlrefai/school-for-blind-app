<?php
namespace App\Http\Controllers;

use App\Http\Middleware\CheckAdminRole;
use App\Models\Announcement;
use Kreait\Laravel\Firebase\Facades\Firebase;
use Illuminate\Http\Request;

class AnnouncementController extends Controller
{
    public function store(Request $request)
    {
        $type = $request->input('type');

        $rules = [
            'type' => 'required|in:normal,exam_schedule',
            'content' => 'required',
            'title' => 'required_if:type,exam_schedule|string|max:255',
        ];

        $rules['content'] = $type === 'exam_schedule' ? 'required|array' : 'required|string';

        $request->validate($rules);


        $announcement = Announcement::create([
            'type' => $type,
            'title' => $request->input('title'),
            'content' => $request->input('content'),
        ]);

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
    $announcements = Announcement::orderBy('created_at', 'desc')->get();

    $processedAnnouncements = $announcements->map(function ($announcement) {

        if (is_string($announcement->content)) {
            $decodedContent = json_decode($announcement->content, true);
            $isJson = (json_last_error() === JSON_ERROR_NONE && is_array($decodedContent));
            $contentData = $isJson ? $decodedContent : $announcement->content;
        } else {
            $contentData = $announcement->content;
            $isJson = is_array($contentData);
        }

        if ($announcement->type === 'exam_schedule') {
            return [
                'id'         => $announcement->id,
                'type'       => $announcement->type,
                'created_at' => $announcement->created_at,
                'updated_at' => $announcement->updated_at,
            ];
        } else {
            return [
                'id'         => $announcement->id,
                'type'       => $announcement->type,
                'content'    => $contentData,
                'created_at' => $announcement->created_at,
                'updated_at' => $announcement->updated_at,
            ];
        }
    });

    return response()->json($processedAnnouncements, 200);
}
    public function showExam($id)
        {
        $announcement = Announcement::query()->whereKey($id)->first();

        if (!$announcement || $announcement->type !== 'exam_schedule') {
            return response()->json([
                'message' => 'برنامج الامتحان غير موجود أو قد تم حذفه'
            ], 404);
        }

        return response()->json([
            'id'           => $announcement->id,
            'type'         => $announcement->type,
            'title'        => $announcement->title,
            'exam_program' => $announcement->content,
            'created_at'   => $announcement->created_at
        ], 200);


}}
