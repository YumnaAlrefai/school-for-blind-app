<?php

namespace App\Traits;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\URL;

trait UploadFileTrait
{
public function getFullUrl($path)
    {
        if (!$path) return null;
return request()->getSchemeAndHttpHost() . '/storage/' . $path;    }
    public function uploadFile(UploadedFile $file, $folder)
    {
        $fileName = time() . '_' . $file->getClientOriginalName();
return route('students.documents.show', ['filename' => $fileName]);    }
    public function generateMagicSignedRoute($routeName, $minutes, $parameters = [])
    {
        URL::forceRootUrl(request()->getSchemeAndHttpHost());

        return URL::temporarySignedRoute(
            $routeName,
            now()->addMinutes($minutes),
            $parameters
        );
    }
}
