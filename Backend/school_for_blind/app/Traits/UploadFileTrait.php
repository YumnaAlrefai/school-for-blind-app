<?php

namespace App\Traits;

use App\Models\Student;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\URL;

trait UploadFileTrait
{

    public function uploadFile(UploadedFile $file, $folder = 'doc')
    {
        $fileName = time() . '_' . $file->getClientOriginalName();

        $file->storeAs($folder, $fileName, 'public');

        return "storage/{$folder}/{$fileName}";
    }
    public function getSignedDocumentUrl($filename)
    {
        if (!$filename)
            return null;

        if (str_starts_with($filename, 'storage/')) {
            return $filename;
        }

        return 'storage/doc/' . basename($filename);
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
}
