@extends('layouts.app')

@section('content')
 <div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
   <h2 class="fw-bold" style="color: var(--text-main);">الامتحانات والمذاكرات الإدارية</h2>
   <a href="{{ route('dashboard.exams.create') }}" class="btn btn-accept px-4 rounded-pill">
    <i class="fa-solid fa-plus me-2"></i> إضافة امتحان جديد
   </a>
  </div>

  <div class="custom-card mb-4 p-3">
   <form action="{{ route('dashboard.exams.index') }}" method="GET" class="row g-3 align-items-center">

    <div class="col-md-4">
     <input type="text" name="search" class="form-control search-input rounded-pill" placeholder="ابحث باسم الامتحان..."
      value="{{ request('search') }}">
    </div>

    <div class="col-md-3">
     <select name="subject_id" class="form-select search-input rounded-pill">
      <option value="">كل المواد</option>
      @foreach($subjects as $subject)
       <option value="{{ $subject->id }}" {{ request('subject_id') == $subject->id ? 'selected' : '' }}>
        {{ $subject->name }}
       </option>
      @endforeach
     </select>
    </div>

    <div class="col-md-3">
     <select name="status" class="form-select search-input rounded-pill">
      <option value="">كل الحالات</option>
      <option value="published" {{ request('status') == 'published' ? 'selected' : '' }}>منشورة</option>
      <option value="draft" {{ request('status') == 'draft' ? 'selected' : '' }}>مسودة</option>
     </select>
    </div>

    <div class="col-md-2">
     <button type="submit" class="btn btn-primary w-100 rounded-pill">
      <i class="fa-solid fa-magnifying-glass me-1"></i> تصفية
     </button>
    </div>
   </form>
  </div>

  <div class="custom-card p-0 overflow-hidden">
   <div class="table-responsive">
    <table class="table table-hover-custom mb-0 text-center"
     style="color: var(--text-main); border-color: var(--border-color);">
     <thead style="background-color: var(--hover-bg);">
      <tr>
       <th class="py-3">#</th>
       <th class="py-3">عنوان الامتحان</th>
       <th class="py-3">المادة</th>
       <th class="py-3">موعد الامتحان</th>
       <th class="py-3">المدة</th>
       <th class="py-3">الحالة</th>
       <th class="py-3">الإجراءات</th>
      </tr>
     </thead>
     <tbody>
      @forelse($exams as $exam)
       <tr>
        <td class="align-middle">{{ $loop->iteration }}</td>
        <td class="align-middle fw-bold">{{ $exam->title }}</td>
        <td class="align-middle">{{ $exam->subject->name ?? 'غير محدد' }}</td>
        <td class="align-middle" dir="ltr">{{ \Carbon\Carbon::parse($exam->exam_date)->format('Y-m-d H:i') }}</td>
        <td class="align-middle">{{ $exam->duration_minutes }} دقيقة</td>
        <td class="align-middle">
         @if($exam->is_published)
          <span class="badge-status bg-soft-success">منشور</span>
         @else
          <span class="badge-status bg-soft-warning">مسودة</span>
         @endif
        </td>
        <td class="align-middle">
         <div class="d-flex justify-content-center gap-2">
          <a href="{{ route('dashboard.exams.show', $exam->id) }}" class="btn btn-sm btn-info text-white"
           title="إدارة الأسئلة والتفاصيل">
           <i class="fa-solid fa-eye"></i>
          </a>
          <a href="{{ route('dashboard.exams.edit', $exam->id) }}" class="btn btn-sm btn-primary" title="تعديل">
           <i class="fa-solid fa-pen-to-square"></i>
          </a>
          <form action="{{ route('dashboard.exams.destroy', $exam->id) }}" method="POST" class="d-inline"
           onsubmit="return confirm('هل أنت متأكد من حذف هذا الامتحان؟');">
           @csrf
           @method('DELETE')
           <button type="submit" class="btn btn-sm btn-reject" title="حذف">
            <i class="fa-solid fa-trash"></i>
           </button>
          </form>
         </div>
        </td>
       </tr>
      @empty
       <tr>
        <td colspan="7" class="text-center py-4 text-muted">لا يوجد امتحانات مضافة حالياً.</td>
       </tr>
      @endforelse
     </tbody>
    </table>
   </div>

   @if($exams->hasPages())
    <div class="d-flex justify-content-center p-3 border-top" style="border-color: var(--border-color) !important;">
     {{ $exams->links() }}
    </div>
   @endif
  </div>

 </div>
@endsection