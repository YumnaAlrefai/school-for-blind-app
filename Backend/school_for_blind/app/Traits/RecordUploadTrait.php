<?php
namespace App\Traits;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

trait RecordUploadTrait
{
    public function uploadRecord(UploadedFile $file, string $folder = 'student_audios', string $disk = 'public'): string
    {
        return $file->store($folder, $disk);
    }

    public function deleteRecord(?string $path, string $disk = 'public'): bool
    {
        if ($path && Storage::disk($disk)->exists($path)) {
            return Storage::disk($disk)->delete($path);
        }
        
        return false;
    }
}