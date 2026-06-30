<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
protected$fillable = [
'title',
'body',
'is_read',
];
public function notifiable()
{
    return $this->morphTo();
}
}
