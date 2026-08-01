@extends('layouts.app')

@section('content')
 <div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
   <h2 class="fw-bold" style="color: var(--text-main);">تعديل الدورة الوزارية</h2>
   <a href="{{ route('dashboard.past-exams.index') }}" class="btn btn-secondary px-4 rounded-pill">
    <i class="fa-solid fa-arrow-right me-2"></i> عودة للقائمة
   </a>
  </div>

  <div class="row justify-content-center">
   <div class="col-lg-8">
    <div class="custom-card">

     {{-- عرض رسائل الخطأ إن وجدت --}}
     @if ($errors->any())
      <div class="alert alert-danger rounded-3">
       <ul class="mb-0">
        @foreach ($errors->all() as $error)
         <li>{{ $error }}</li>
        @endforeach
       </ul>
      </div>
     @endif

     <form action="{{ route('dashboard.past-exams.update', $pastExam->id) }}" method="POST"
      enctype="multipart/form-data">
      @csrf
      @method('PUT')

      {{-- اسم الدورة --}}
      <div class="mb-4">
       <label for="title" class="form-label fw-bold" style="color: var(--text-main);">عنوان الدورة <span
         class="text-danger">*</span></label>
       <input type="text" name="title" id="title" class="form-control search-input" required
        placeholder="مثال: دورة 2023 - رياضيات" value="{{ old('title', $pastExam->title) }}">
      </div>

      <div class="row mb-4">
       {{-- المادة --}}
       <div class="col-md-6">
        <label for="subject_id" class="form-label fw-bold" style="color: var(--text-main);">المادة <span
          class="text-danger">*</span></label>
        <select name="subject_id" id="subject_id" class="form-select search-input" required>
         <option value="" disabled>-- اختر المادة --</option>
         @foreach($subjects as $subject)
          <option value="{{ $subject->id }}" {{ old('subject_id', $pastExam->subject_id) == $subject->id ? 'selected' : '' }}>
           {{ $subject->name }}
          </option>
         @endforeach
        </select>
       </div>

       {{-- السنة الدراسية --}}
       <div class="col-md-6">
        <label for="year" class="form-label fw-bold" style="color: var(--text-main);">السنة الدراسية <span
          class="text-danger">*</span></label>
        <input type="number" name="year" id="year" class="form-control search-input" required min="2000"
         max="{{ date('Y') + 1 }}" value="{{ old('year', $pastExam->year) }}">
       </div>
      </div>

      <div class="row mb-4">
       {{-- الفصل / الدورة --}}
       <div class="col-md-6">
        <label for="session" class="form-label fw-bold" style="color: var(--text-main);">الدورة <span
          class="text-danger">*</span></label>
        <select name="session" id="session" class="form-select search-input" required>
         <option value="first" {{ old('session', $pastExam->session) == 'first' ? 'selected' : '' }}>الأولى</option>
         <option value="second" {{ old('session', $pastExam->session) == 'second' ? 'selected' : '' }}>الثانية</option>
         <option value="complementary" {{ old('session', $pastExam->session) == 'complementary' ? 'selected' : '' }}>
          تكميلية</option>
        </select>
       </div>

       {{-- رفع ملف صوتي جديد --}}
       <div class="col-md-6">
        <label for="voice_solution" class="form-label fw-bold" style="color: var(--text-main);">تحديث ملف الحل الصوتي
         الشامل</label>
        <input type="file" name="voice_solution" id="voice_solution" class="form-control search-input" accept="audio/*">
        <small style="color: var(--text-muted);">اتركه فارغاً للاحتفاظ بالملف الحالي (mp3, wav, aac بحد أقصى:
         20MB)</small>
       </div>
      </div>

      {{-- استعراض وتشغيل الملف الصوتي الحالي إن وجد --}}
      @if($pastExam->voice_solution_path)
       <div class="p-3 mb-4 rounded-3 d-flex flex-column gap-2"
        style="background-color: var(--bg-main); border: 1px solid var(--border-color);">
        <span class="fw-bold" style="color: var(--text-main); font-size: 0.9rem;">
         <i class="fa-solid fa-volume-high me-1 text-success"></i> ملف الحل الصوتي الحالي المرفوع:
        </span>
        <audio controls class="w-100 mt-1">
         <source src="{{ asset('storage/' . $pastExam->voice_solution_path) }}" type="audio/mpeg">
         متصفحك لا يدعم مشغل الصوت المدمج.
        </audio>
       </div>
      @endif

      {{-- أزرار التحكم --}}
      <div class="d-flex justify-content-between align-items-center mt-5">
       <div>
        @if(!$pastExam->is_published)
         <span class="badge-status bg-soft-warning fs-6"><i class="fa-solid fa-circle-dot me-1"></i> الحالة الحالية:
          مسودة</span>
        @else
         <span class="badge-status bg-soft-success fs-6"><i class="fa-solid fa-circle-check me-1"></i> الحالة الحالية:
          منشورة للطلاب</span>
        @endif
       </div>
       <button type="submit" class="btn btn-accept px-5 py-2 rounded-pill fs-5">
        <i class="fa-solid fa-circle-check me-2"></i> تحديث البيانات
       </button>
      </div>

     </form>
    </div>
   </div>
  </div>
 </div>
@endsection