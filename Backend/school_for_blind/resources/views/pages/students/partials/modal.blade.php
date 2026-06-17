<div class="modal fade" id="studentModal{{ $student->id }}" tabindex="-1" aria-hidden="true">
 <div class="modal-dialog modal-dialog-centered modal-lg">
  <div class="modal-content text-end" dir="rtl"
   style="background-color: var(--bg-main); border: 1px solid var(--border-color);">
   <div class="modal-header d-flex justify-content-between" style="border-bottom: 1px solid var(--border-color);">
    <h5 class="modal-title fw-bold" style="color: var(--text-main);">التفاصيل الكاملة للطالب</h5>
    <button type="button" class="btn-close m-0" data-bs-dismiss="modal" aria-label="Close"></button>
   </div>
   <div class="modal-body">
    <div class="row g-4 mb-4">
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">الاسم الكامل</small>
       <strong style="color: var(--text-main);">{{ $student->fullname }}</strong>
      </div>
     </div>
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">اسم الأب</small>
       <strong style="color: var(--text-main);">{{ $student->fathersname }}</strong>
      </div>
     </div>
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">رقم الطالب</small>
       <strong style="color: var(--text-main);" dir="ltr">{{ $student->phone }}</strong>
      </div>
     </div>
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">رقم ولي الأمر</small>
       <strong style="color: var(--text-main);" dir="ltr">{{ $student->parent_phone }}</strong>
      </div>
     </div>
     <div class="col-md-4">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">النقاط الحالية</small>
       <strong style="color: var(--text-main);">{{ $student->points }}</strong>
      </div>
     </div>
     <div class="col-md-4">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">إجمالي النقاط المكتسبة</small>
       <strong style="color: var(--text-main);">{{ $student->total_earned_points }}</strong>
      </div>
     </div>
     <div class="col-md-4">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">الصف</small>
       <strong style="color: var(--text-main);">{{ $student->class->name ?? 'غير محدد' }}</strong>
      </div>
     </div>

     {{-- زر عرض المستند الثبوتي --}}
     @if($student->DocumentaryEvidence)
      <div class="col-12">
       <a href="{{ $student->DocumentaryEvidence }}" target="_blank" class="btn btn-primary w-100 py-2">
        <i class="fa-solid fa-file-image me-2"></i> عرض المستند الثبوتي
       </a>
      </div>
     @endif

    </div>
   </div>
  </div>
 </div>
</div>