<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
    protected$fillable = [
//'student_id',
'from_who',
'to_who',
'reason',
'punishment_id',
    ];
}
