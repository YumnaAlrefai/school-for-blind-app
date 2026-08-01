@extends('layouts.app')

@section('content')
  <div class="row g-4 mb-4">
    <div class="col-12">
      <div class="custom-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h5 class="fw-bold mb-0" style="color: var(--text-main);">سجلاتنا</h5>
        </div>

        <div class="table-responsive">
          <table class="table table-hover-custom align-middle mb-0" style="color: var(--text-main);">
            <thead>
              <tr style="border-bottom: 2px solid var(--border-color);">
                <th scope="col" class="pb-3 text-muted fw-normal">الأنشطة</th>
                <th scope="col" class="pb-3 text-muted fw-normal">القسم</th>
                <th scope="col" class="pb-3 text-muted fw-normal">الحالة</th>
                <th scope="col" class="pb-3 text-muted fw-normal text-start">التاريخ</th>
              </tr>
            </thead>
            <tbody>
              @forelse($activities as $log)
                <tr style="border-bottom: 1px solid var(--border-color);">
                  <td class="py-3">
                    <div class="d-flex align-items-center">
                      <div class="rounded-circle p-2 me-2 d-flex align-items-center justify-content-center"
                        style="width: 35px; height: 35px; background-color: var(--bg-main);">
                        @if($log->event === 'created')
                          <i class="fa-solid fa-plus text-success fs-6"></i>
                        @elseif($log->event === 'updated')
                          <i class="fa-solid fa-pen text-warning fs-6"></i>
                        @elseif($log->event === 'deleted')
                          <i class="fa-solid fa-trash text-danger fs-6"></i>
                        @else
                          <i class="fa-solid fa-file-signature text-info fs-6"></i>
                        @endif
                      </div>
                      {{-- <span>
                        {{ $log->getExtraProperty('custom_info.lesson_name') ?? 'تحديث على بيانات ' .
                        class_basename($log->subject_type) }}
                      </span> --}}
                    </div>
                  </td>

                  <td class="py-3 text-muted">
                    {{ class_basename($log->subject_type) }}
                  </td>

                  <td class="py-3">
                    @php
                      $eventColors = ['created' => 'success', 'updated' => 'warning', 'deleted' => 'danger'];
                      $eventNames = ['created' => 'إنشاء', 'updated' => 'تعديل', 'deleted' => 'حذف'];
                      $color = $eventColors[$log->event] ?? 'info';
                      $name = $eventNames[$log->event] ?? $log->event;
                    @endphp
                    <span class="badge-status bg-soft-{{ $color }} text-{{ $color }} px-2 py-1 rounded">
                      {{ $name }}
                    </span>
                  </td>

                  <td class="py-3 text-muted text-start">
                    {{-- ضفنا div وجمعنا فيه الـ flex بدال ما نخليه على الـ td --}}
                    <div class="d-flex justify-content-between align-items-center">
                      <span>{{ $log->created_at->format('Y-m-d') }}</span>

                      {{-- زر التفاصيل
                      <button type="button" class="btn btn-sm btn-outline-secondary ms-2" data-bs-toggle="modal"
                        data-bs-target="#logModal{{ $log->id }}">
                        <i class="fa-solid fa-eye"></i>
                      </button>
                    </div>
                  </td> --}}

                  <button type="button" class="btn btn-sm btn-outline-secondary ms-2" data-bs-toggle="modal"
                    data-bs-target="#logModal{{ $log->id }}">
                    <i class="fa-solid fa-eye"></i>
                  </button>
                  </td>
                </tr>

                <div class="modal fade" id="logModal{{ $log->id }}" tabindex="-1" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content text-end" dir="rtl">
                      <div class="modal-header d-flex justify-content-between">
                        <h5 class="modal-title">تفاصيل العملية ({{ $name }})</h5>
                        <button type="button" class="btn-close m-0" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body text-start" dir="ltr">
                        @if(isset($log->properties['custom_info']) && is_array($log->properties['custom_info']))
                          <div class="mb-4 p-3 rounded"
                            style="background-color: var(--hover-bg); border: 1px solid var(--border-color);">
                            <h6 class="text-end fw-bold mb-3" style="color: var(--text-main);">:معلومات إضافية</h6>
                            <div class="row text-end" dir="rtl">
                              @foreach($log->properties['custom_info'] as $key => $value)
                                <div class="col-md-4 col-6 mb-3">
                                  <small class="text-muted d-block">{{ ucfirst(str_replace('_', ' ', $key)) }}</small>
                                  <strong style="color: var(--text-main);">
                                    {{ is_array($value) ? json_encode($value, JSON_UNESCAPED_UNICODE) : ($value ?? '-') }}
                                  </strong>
                                </div>
                              @endforeach

                            </div>
                          </div>
                        @endif
                        @if(isset($log->properties['attributes']))
                          <h6 class="text-success text-end">:القيم (الجديدة)</h6>
                          <pre
                            class="p-2 rounded"><code>{{ json_encode($log->properties['attributes'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) }}</code></pre>
                        @endif

                        @if(isset($log->properties['old']))
                          <h6 class="text-danger text-end mt-3">:القيم (القديمة)</h6>
                          <pre
                            class="p-2 rounded"><code>{{ json_encode($log->properties['old'], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE) }}</code></pre>
                        @endif

                        @if(!isset($log->properties['attributes']) && !isset($log->properties['old']))
                          <p class="text-muted text-end">لا توجد تفاصيل إضافية مسجلة لهذه العملية.</p>
                        @endif
                      </div>
                    </div>
                  </div>
                </div>
              @empty
                <tr>
                  <td colspan="4" class="text-center py-4 text-muted">لا توجد سجلات.</td>
                </tr>
              @endforelse
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
@endsection