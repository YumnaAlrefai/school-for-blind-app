<div class="modal fade" id="teacherModal{{ $teacher->id }}" tabindex="-1" aria-hidden="true">
 <div class="modal-dialog modal-dialog-centered modal-lg">
  {{-- أضفنا كلاس glass-modal وحذفنا لون الخلفية الصلب --}}
  <div class="modal-content glass-modal text-end" dir="rtl"
   style="border: 1px solid var(--border-color); color: var(--text-main);">
   <div class="modal-header d-flex justify-content-between" style="border-bottom: 1px solid var(--border-color);">
    <h5 class="modal-title fw-bold" style="color: var(--text-main);">التفاصيل الكاملة للمعلم</h5>
    <button type="button" class="btn-close m-0" data-bs-dismiss="modal" aria-label="Close"></button>
   </div>
   <div class="modal-body">
    <div class="row g-4 mb-4">
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">الاسم الكامل</small>
       <strong style="color: var(--text-main);">{{ $teacher->full_name }}</strong>
      </div>
     </div>
     <div class="col-md-6">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-1">رقم الهاتف</small>
       <strong style="color: var(--text-main);" dir="ltr">{{ $teacher->phone }}</strong>
      </div>
     </div>
     <div class="col-12">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-2">المواد التي يدرسها</small>
       <div class="d-flex flex-wrap gap-2">
        @forelse($teacher->subjects()->get() as $subject)
         <span class="badge border"
          style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color) !important;">
          {{ $subject->name ?? 'مادة' }} ({{ $subject->pivot->price_for_lesson ?? 0 }} ل.س)
         </span>
        @empty
         <span style="color: var(--text-main);">لا يوجد مواد مرتبطة</span>
        @endforelse
       </div>
      </div>
     </div>
     <div class="col-12">
      <div class="p-3 rounded" style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
       <small class="text-muted d-block mb-2">الصفوف المرتبطة</small>
       <div class="d-flex flex-wrap gap-2">
        @forelse($teacher->classes as $class)
         <span class="badge bg-secondary">{{ $class->name ?? 'صف' }}</span>
        @empty
         <span style="color: var(--text-main);">لا يوجد صفوف مرتبطة</span>
        @endforelse
       </div>
      </div>
     </div>
     @if($teacher->cv_path)
      <div class="col-12">
       <a href="{{ asset('storage/' . $teacher->cv_path) }}" target="_blank" class="btn btn-primary w-100 py-2">
        <i class="fa-solid fa-file-arrow-down me-2"></i> تحميل وعرض السيرة الذاتية
       </a>
      </div>
     @endif
    </div>