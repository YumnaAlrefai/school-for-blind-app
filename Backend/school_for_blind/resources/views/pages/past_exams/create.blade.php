@extends('layouts.app') {{-- عدلها حسب اسم الـ layout تبعك --}}

@section('content')
 <div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
   <h2 class="fw-bold" style="color: var(--text-main);">إضافة دورة وزارية جديدة (مسودة)</h2>
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

     <form action="{{ route('dashboard.past-exams.store') }}" method="POST" enctype="multipart/form-data">
      @csrf

      <div class="mb-4">
       <label for="title" class="form-label fw-bold" style="color: var(--text-main);">عنوان الدورة <span
         class="text-danger">*</span></label>
       <input type="text" name="title" id="title" class="form-control search-input" required
        placeholder="مثال: دورة 2023 - رياضيات" value="{{ old('title') }}">
      </div>

      <div class="row mb-4">
       <div class="col-md-6">
        <label for="subject_id" class="form-label fw-bold" style="color: var(--text-main);">المادة <span
          class="text-danger">*</span></label>
        <select name="subject_id" id="subject_id" class="form-select search-input" required>
         <option value="" selected disabled>-- اختر المادة --</option>
         @foreach($subjects as $subject)
          <option value="{{ $subject->id }}" {{ old('subject_id') == $subject->id ? 'selected' : '' }}>
           {{ $subject->name }}
          </option>
         @endforeach
        </select>
       </div>

       <div class="col-md-6">
        <label for="year" class="form-label fw-bold" style="color: var(--text-main);">السنة الدراسية <span
          class="text-danger">*</span></label>
        <input type="number" name="year" id="year" class="form-control search-input" required min="2000"
         max="{{ date('Y') + 1 }}" value="{{ old('year', date('Y')) }}">
       </div>
      </div>

      <div class="row mb-4">
       <div class="col-md-6">
        <label for="session" class="form-label fw-bold" style="color: var(--text-main);">الدورة <span
          class="text-danger">*</span></label>
        <select name="session" id="session" class="form-select search-input" required>
         <option value="first" {{ old('session') == 'first' ? 'selected' : '' }}>الأولى</option>
         <option value="second" {{ old('session') == 'second' ? 'selected' : '' }}>الثانية</option>
         <option value="complementary" {{ old('session') == 'complementary' ? 'selected' : '' }}>تكميلية</option>
        </select>
       </div>

       <div class="col-md-6">
        <label for="voice_solution" class="form-label fw-bold" style="color: var(--text-main);">ملف الحل الصوتي الشامل
         (اختياري)</label>
        <input type="file" name="voice_solution" id="voice_solution" class="form-control search-input" accept="audio/*">
        <small style="color: var(--text-muted);">الملفات المدعومة: mp3, wav, aac (الحد الأقصى: 20MB)</small>
       </div>
      </div>

      <div class="d-flex justify-content-end mt-5">
       <button type="submit" class="btn btn-accept px-5 py-2 rounded-pill fs-5">
        <i class="fa-solid fa-save me-2"></i> حفظ كمسودة
       </button>
      </div>

     </form>
    </div>
   </div>
  </div>
 </div>
@endsection