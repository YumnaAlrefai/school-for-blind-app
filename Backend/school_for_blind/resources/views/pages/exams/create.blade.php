@extends('layouts.app')

@section('content')
 <div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
   <h2 class="fw-bold" style="color: var(--text-main);">إضافة امتحان / مذاكرة جديدة (مسودة)</h2>
   <a href="{{ route('dashboard.exams.index') }}" class="btn btn-secondary px-4 rounded-pill">
    <i class="fa-solid fa-arrow-right me-2"></i> عودة للقائمة
   </a>
  </div>

  <div class="row justify-content-center">
   <div class="col-lg-8">
    <div class="custom-card">

     @if ($errors->any())
      <div class="alert alert-danger rounded-3">
       <ul class="mb-0">
        @foreach ($errors->all() as $error)
         <li>{{ $error }}</li>
        @endforeach
       </ul>
      </div>
     @endif

     <form action="{{ route('dashboard.exams.store') }}" method="POST">
      @csrf

      <div class="mb-4">
       <label for="title" class="form-label fw-bold" style="color: var(--text-main);">عنوان الامتحان <span
         class="text-danger">*</span></label>
       <input type="text" name="title" id="title" class="form-control search-input" required
        placeholder="مثال: مذاكرة الفصل الأول - رياضيات" value="{{ old('title') }}">
      </div>

      <div class="mb-4">
       <label for="description" class="form-label fw-bold" style="color: var(--text-main);">تفاصيل / نطاق
        الامتحان</label>
       <textarea name="description" id="description" class="form-control search-input" rows="3"
        placeholder="مثال: يرجى التركيز على أول 3 دروس، الامتحان يشمل كذا وكذا...">{{ old('description') }}</textarea>
      </div>

      <div class="row mb-4">
       <div class="col-md-12">
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
      </div>

      <div class="row mb-4">
       <div class="col-md-6">
        <label for="exam_date" class="form-label fw-bold" style="color: var(--text-main);">موعد الامتحان (التاريخ والوقت)
         <span class="text-danger">*</span></label>
        <input type="datetime-local" name="exam_date" id="exam_date" class="form-control search-input" required
         value="{{ old('exam_date') }}">
       </div>

       <div class="col-md-6">
        <label for="duration_minutes" class="form-label fw-bold" style="color: var(--text-main);">المدة (بالدقائق) <span
          class="text-danger">*</span></label>
        <input type="number" name="duration_minutes" id="duration_minutes" class="form-control search-input" required
         min="5" max="300" value="{{ old('duration_minutes', 60) }}">
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