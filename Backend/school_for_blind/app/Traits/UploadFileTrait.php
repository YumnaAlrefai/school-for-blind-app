<?php

namespace App\Traits;

use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\URL;

trait UploadFileTrait
{
public function uploadFile(UploadedFile $file, $folder)
    {
        $fileName = time() . '_' . $file->getClientOriginalName();
        $file->storeAs($folder, $fileName);
        return $fileName;
    }

public function getSignedDocumentUrl($filename)
{
    if (!$filename) return null;

    $cleanFilename = basename($filename);

   return '/api/students/documents/' . $cleanFilename;

}
    public function generateMagicSignedRoute($routeName, $minutes, $parameters = [])
    {
        URL::forceRootUrl(request()->getSchemeAndHttpHost());

        return URL::temporarySignedRoute(
            $routeName,
            now()->addMinutes($minutes),
            $parameters
        );
    }
public function showView(Request $request, $id)
{
    $student = Student::findOrFail($id);

    $documentUrl = $this->getSignedDocumentUrl($student->DocumentaryEvidence);

    $postUrl = $this->generateMagicSignedRoute('student.magic.generate', 15, ['id' => $student->id]);

    return view('magic-login-page', [
        'student' => $student,
        'postUrl' => $postUrl,
        'documentUrl' => $documentUrl,
            ]);
}




    }
