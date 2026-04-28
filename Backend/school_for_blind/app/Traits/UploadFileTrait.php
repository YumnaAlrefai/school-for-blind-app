<?php

namespace App\Traits;

use Illuminate\Http\UploadedFile;

trait UploadFileTrait
{

    public function uploadFile(UploadedFile $file, $folder)
    {
        $fileName = time() . '_' . $file->getClientOriginalName();
        return $file->storeAs($folder, $fileName, 'public');
    }
}
