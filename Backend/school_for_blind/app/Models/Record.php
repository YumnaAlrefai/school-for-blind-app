<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Casts\Attribute;

class Record extends Model
{
    use SoftDeletes;

    protected $guarded = [];

    protected $appends = ['name', 'url'];

    public function recordable()
    {
        return $this->morphTo();
    }

    protected function url(): Attribute
    {
        return Attribute::make(
            get: fn() => asset('storage/' . $this->record_path),
        );
    }

    protected function name(): Attribute
    {
        return Attribute::make(
            get: function () {
                if (!$this->recordable_id) {
                    return 'قسم 1';
                }

                $count = static::where('recordable_type', $this->recordable_type)
                    ->where('recordable_id', $this->recordable_id)
                    ->where('id', '<=', $this->id)
                    ->count();

                return 'قسم ' . ($count > 0 ? $count : 1);
            }
        );
    }
}