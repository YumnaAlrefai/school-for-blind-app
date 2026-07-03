@extends('layouts.app')

@section('content')
 <div class="container-fluid py-4">

  <div class="d-flex justify-content-between align-items-center mb-4">
   <h2 class="fw-bold" style="color: var(--text-main);">تفاصيل الامتحان / المذاكرة</h2>
   <a href="{{ route('dashboard.exams.index') }}" class="btn btn-secondary px-4 rounded-pill">
    <i class="fa-solid fa-arrow-right me-2"></i> عودة للقائمة
   </a>
  </div>

  @if ($errors->any())
   <div class="alert alert-danger rounded-3 mb-4">
    <ul class="mb-0">
     @foreach ($errors->all() as $error)
      <li>{{ $error }}</li>
     @endforeach
    </ul>
   </div>
  @endif

  @if(session('success'))
   <div class="alert alert-success rounded-3 mb-4">
    {{ session('success') }}
   </div>
  @endif

  @if(session('error'))
   <div class="alert alert-danger rounded-3 mb-4">
    {{ session('error') }}
   </div>
  @endif

  <div class="row g-4">
   <div class="col-xl-4">
    <div class="custom-card mb-4">
     <h4 class="fw-bold mb-3" style="color: var(--text-main);">المعلومات الأساسية</h4>
     <hr style="border-color: var(--border-color);">

     <div class="mb-3">
      <span class="text-muted d-block small">عنوان الامتحان</span>
      <strong class="fs-5" style="color: var(--text-main);">{{ $exam->title }}</strong>
     </div>

     @if($exam->description)
      <div class="mb-3">
       <span class="text-muted d-block small">تفاصيل ونطاق الامتحان</span>
       <p class="m-0 small" style="color: var(--text-main);">{{ $exam->description }}</p>
      </div>
     @endif

     <div class="mb-3">
      <span class="text-muted d-block small">المادة</span>
      <strong style="color: var(--text-main);">{{ $exam->subject->name ?? 'غير محدد' }}</strong>
     </div>

     <div class="row mb-3">
      <div class="col-6">
       <span class="text-muted d-block small">موعد الامتحان</span>
       <strong style="color: var(--text-main);"
        dir="ltr">{{ \Carbon\Carbon::parse($exam->exam_date)->format('Y-m-d H:i') }}</strong>
      </div>
      <div class="col-6">
       <span class="text-muted d-block small">المدة الزمنية</span>
       <strong style="color: var(--text-main);">{{ $exam->duration_minutes }} دقيقة</strong>
      </div>
     </div>

     <div class="mb-4">
      <span class="text-muted d-block small">الحالة الحالية</span>
      @if($exam->is_published)
       <span class="badge-status bg-soft-success mt-1">منشور للطلاب</span>
      @else
       <span class="badge-status bg-soft-warning mt-1">مسودة غير منشور</span>
      @endif
     </div>

     <div class="d-grid gap-2">
      @if(!$exam->is_published)
       <form action="{{ route('dashboard.exams.publish', $exam->id) }}" method="POST">
        @csrf
        <button type="submit" class="btn btn-accept w-100 rounded-pill py-2 fw-bold">
         <i class="fa-solid fa-paper-plane me-2"></i> نشر الامتحان للطلاب الآن
        </button>
       </form>
      @endif
      <a href="{{ route('dashboard.exams.edit', $exam->id) }}" class="btn btn-outline-primary rounded-pill py-2">
       <i class="fa-solid fa-pen-to-square me-2"></i> تعديل البيانات الأساسية
      </a>
     </div>
    </div>

    <div class="custom-card">
     <h4 class="fw-bold mb-3" style="color: var(--text-main);">إجراءات الأسئلة</h4>
     <hr style="border-color: var(--border-color);">
     <div class="d-grid gap-3">
      <button type="button" class="btn btn-primary rounded-pill py-2 fw-bold" data-bs-toggle="modal"
       data-bs-target="#createQuestionModal">
       <i class="fa-solid fa-plus me-2"></i> إنشاء سؤال تفاعلي جديد
      </button>
     </div>
    </div>
   </div>

   <div class="col-xl-8">
    <div class="custom-card h-100">
     <div class="d-flex justify-content-between align-items-center mb-3">
      <h4 class="fw-bold m-0" style="color: var(--text-main);">الأسئلة المرتبطة بالامتحان
       ({{ $exam->questions->count() }})</h4>
     </div>
     <hr style="border-color: var(--border-color);">

     <div class="d-flex flex-column gap-4">
      @forelse($exam->questions as $question)
       <div class="p-3 rounded-3" style="background-color: var(--bg-main); border: 1px solid var(--border-color);">
        <div class="d-flex justify-content-between align-items-start mb-2">
         <div>
          <span class="badge bg-secondary me-2">
           @if($question->type == 'mcq') خيارات
           @elseif($question->type == 'TF') صح / خطأ
           @else مقالي @endif
          </span>
          <span class="text-muted small">الدرجات: <strong>{{ $question->points }}</strong></span>
         </div>
         <form action="{{ route('dashboard.exams.questions.detach', [$exam->id, $question->id]) }}" method="POST"
          onsubmit="return confirm('هل أنت متأكد من إزالة هذا السؤال من الامتحان؟');">
          @csrf
          @method('DELETE')
          <button type="submit" class="btn btn-sm btn-reject rounded-circle p-2" title="إزالة من الامتحان">
           <i class="fa-solid fa-minus"></i>
          </button>
         </form>
        </div>

        <p class="fw-bold mb-3" style="color: var(--text-main);">{{ $question->description }}</p>

        @if($question->type == 'mcq')
         <div class="row g-2">
          @foreach($question->choices as $choice)
           <div class="col-md-6">
            <div class="p-2 rounded-2 d-flex align-items-center justify-content-between"
             style="background-color: var(--hover-bg); border: 1px solid {{ $choice->is_correct ? '#a3e635' : 'var(--border-color)' }};">
             <span style="color: var(--text-main);">{{ $choice->choice_text }}</span>
             @if($choice->is_correct)
              <i class="fa-solid fa-circle-check text-success"></i>
             @endif
            </div>
           </div>
          @endforeach
         </div>
        @elseif($question->type == 'TF')
         <div class="p-2 rounded-2 fw-bold"
          style="background-color: var(--hover-bg); color: var(--text-main); border-right: 4px solid #a3e635;">
          الإجابة الصحيحة: {{ $question->correct_answer == 'T' ? 'صح' : 'خطأ' }}
         </div>
        @else
         <div class="p-2 rounded-2"
          style="background-color: var(--hover-bg); color: var(--text-main); border-right: 4px solid #06b6d4;">
          <span class="text-muted small d-block">نموذج الإجابة الصحيحة:</span>
          <strong>{{ $question->correct_answer }}</strong>
         </div>
        @endif
       </div>
      @empty
       <div class="text-center py-5 text-muted">
        <i class="fa-solid fa-circle-question fs-1 d-block mb-3"></i>
        لا توجد أسئلة مرتبطة بهذا الامتحان حالياً. يمكنك إنشاء سؤال جديد.
       </div>
      @endforelse
     </div>
    </div>
   </div>
  </div>
 </div>

 <div class="modal fade" id="createQuestionModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
   <div class="modal-content glass-modal"
    style="background: var(--card-bg); border: 1px solid var(--border-color); color: var(--text-main);">
    <div class="modal-header border-0">
     <h5 class="modal-title fw-bold">إنشاء سؤال تفاعلي جديد</h5>
     <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>
    <form action="{{ route('dashboard.exams.questions.store', $exam->id) }}" method="POST">
     @csrf
     <div class="modal-body">
      <div class="row mb-3">
       <div class="col-md-6">
        <label class="form-label fw-bold">نوع السؤال</label>
        <select name="type" class="form-select search-input" required onchange="toggleQuestionFields(this.value)">
         <option value="mcq">خيارات من متعدد (mcq)</option>
         <option value="TF">صح وخطأ (TF)</option>
         <option value="TEXT">سؤال مقالي كتابي (TEXT)</option>
        </select>
       </div>
       <div class="col-md-6">
        <label class="form-label fw-bold">الدرجات / النقاط</label>
        <input type="number" name="points" class="form-control search-input" step="0.5" min="0" required value="1">
       </div>
      </div>

      <div class="mb-4">
       <label class="form-label fw-bold">نص السؤال</label>
       <textarea name="description" class="form-control search-input" rows="3" required
        placeholder="اكتب نص السؤال هنا..."></textarea>
      </div>

      <div id="mcq_fields_wrapper">
       <label class="form-label fw-bold mb-2">الخيارات المتاحة (حدد الخيار الصحيح)</label>
       <div class="d-flex flex-column gap-2">
        @for($i = 0; $i < 4; $i++)
         <div class="input-group">
          <div class="input-group-text" style="background-color: var(--hover-bg); border-color: var(--border-color);">
           <input class="form-check-input mt-0" type="radio" name="correct_choice" value="{{ $i }}" {{ $i == 0 ? 'checked' : '' }}>
          </div>
          <input type="text" name="choices[{{ $i }}][text]" class="form-control search-input"
           placeholder="نص الخيار رقم {{ $i + 1 }}">
         </div>
        @endfor
       </div>
      </div>

      <div id="correct_answer_wrapper" class="d-none">
       <label class="form-label fw-bold">الإجابة الصحيحة</label>

       <select id="tf_input" class="form-select search-input d-none">
        <option value="T">صح (T)</option>
        <option value="F">خطأ (F)</option>
       </select>

       <textarea id="text_input" class="form-control search-input d-none" rows="2"
        placeholder="أدخل نموذج الإجابة الصحيحة..."></textarea>
      </div>
     </div>
     <div class="modal-footer border-0">
      <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-toggle="modal">إلغاء</button>
      <button type="submit" class="btn btn-accept rounded-pill px-5">حفظ السؤال</button>
     </div>
    </form>
   </div>
  </div>
 </div>

 <script>
  function toggleQuestionFields(type) {
   const mcqWrapper = document.getElementById('mcq_fields_wrapper');
   const answerWrapper = document.getElementById('correct_answer_wrapper');
   const tfInput = document.getElementById('tf_input');
   const textInput = document.getElementById('text_input');

   mcqWrapper.classList.add('d-none');
   answerWrapper.classList.add('d-none');
   tfInput.classList.add('d-none');
   textInput.classList.add('d-none');

   tfInput.removeAttribute('name');
   textInput.removeAttribute('name');

   if (type === 'mcq') {
    mcqWrapper.classList.remove('d-none');
   } else if (type === 'TF') {
    answerWrapper.classList.remove('d-none');
    tfInput.classList.remove('d-none');
    tfInput.setAttribute('name', 'correct_answer');
   } else if (type === 'TEXT') {
    answerWrapper.classList.remove('d-none');
    textInput.classList.remove('d-none');
    textInput.setAttribute('name', 'correct_answer');
   }
  }
 </script>
@endsection