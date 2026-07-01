@extends('layouts.app')

@section('content')
 <div class="container-fluid py-4">
  <div class="d-flex align-items-center justify-content-between mb-4">
   <div>
    <h3 class="fw-bold mb-1" style="color: var(--text-main);">الدروس والمكالمات الجارية</h3>
    <p style="color: var(--text-muted); font-size: 0.9rem;">مراقبة مباشرة للحصص الافتراضية النشطة على السيرفر حالياً</p>
   </div>
   <span class="badge-status bg-soft-success">
    عدد الدروس النشطة: {{ $activeCalls->count() }}
   </span>
  </div>

  <div class="custom-card p-4">
   @if($activeCalls->isEmpty())
    <div class="text-center py-5">
     <i class="fa-solid fa-video-slash fs-1 text-muted mb-3"></i>
     <h5 style="color: var(--text-main);">لا توجد مكالمات أو دروس نشطة حالياً</h5>
     <p style="color: var(--text-muted); font-size: 0.9rem;">عندما يبدأ أي أستاذ درساً جديداً، سيظهر هنا فوراً.</p>
    </div>
   @else
    <div class="table-responsive">
     <table class="table table-hover-custom align-middle" style="color: var(--text-main);">
      <thead>
       <tr style="color: var(--text-muted); border-bottom: 2px solid var(--border-color);">
        <th>اسم الدرس / الغرفة</th>
        <th>الأستاذ المنشئ</th>
        <th>الشعبة المستهدفة</th>
        <th>وقت البدء</th>
        <th class="text-center">الإجراءات</th>
       </tr>
      </thead>
      <tbody>
       @foreach($activeCalls as $call)
        <tr style="border-bottom: 1px solid var(--border-color);">
         <td class="fw-bold">
          <span style="color: var(--accent-color); font-size: 1.1rem; margin-left: 5px;">●</span>
          {{ $call->room_name }}
         </td>
         <td>
          <div class="d-flex align-items-center gap-2">
           <i class="fa-solid fa-user-tie text-muted"></i>
           <span>{{ $call->creator->full_name ?? $call->creator->name ?? 'غير معروف' }}</span>
          </div>
         </td>
         <td>
          <span class="badge bg-soft-info px-2 py-1" style="font-size: 0.85rem;">
           <i class="fa-regular fa-folder-open me-1"></i>
           {{ $call->class->name ?? 'شعبة ' . $call->class_id }}
          </span>
         </td>
         <td style="color: var(--text-muted); font-size: 0.9rem;">
          {{ $call->created_at->diffForHumans() }}
         <td class="text-center">
          <a href="{{ route('admin.join-call', $call->room_name) }}"
           class="btn px-3 py-1.5 d-inline-flex align-items-center gap-2 fw-bold text-white shadow-sm"
           style="background-color: var(--accent-color); border: none; border-radius: 8px; font-size: 0.9rem;">
           <i class="fa-solid fa-eye"></i>
           دخول ومراقبة الدرس
          </a>
         </td>
        </tr>
       @endforeach
      </tbody>
     </table>
    </div>
   @endif
  </div>
 </div>
@endsection