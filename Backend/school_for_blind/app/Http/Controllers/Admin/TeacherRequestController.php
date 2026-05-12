<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Teacher;
use function PHPUnit\Framework\returnArgument;

class TeacherRequestController extends Controller
{
    public function index()
    {
        $teachers = Teacher::where('status', 'pending')->get();
        return view('teacher.request', compact('teachers'));
    }
}
