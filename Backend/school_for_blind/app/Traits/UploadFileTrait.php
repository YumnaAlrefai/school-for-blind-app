<?php

namespace App\Traits;

use Illuminate\Http\UploadedFile;

trait UploadFileTrait
{
public function getFullUrl($path)
    {
        if (!$path) return null;
        return asset('storage/' . $path);
    }
    public function uploadFile(UploadedFile $file, $folder)
    {
        $fileName = time() . '_' . $file->getClientOriginalName();
        return $file->storeAs($folder, $fileName, 'public');
    }
}
