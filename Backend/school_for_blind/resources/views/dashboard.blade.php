@extends('layouts.app')

@section('content')
  <div class="container-fluid p-0">

    <div class="row g-4 mb-4">

      <div class="col-lg-4">
        <div class="row g-3">
          <div class="col-12">
            <a href="{{ route('students.index') }}" class="text-decoration-none d-block">
              <div class="custom-card d-flex justify-content-between align-items-center shadow-sm-hover"
                style="transition: transform 0.2s;">
                <div>
                  <p class="text-muted mb-1 fs-5">إجمالي الطلاب</p>
                  <h3 class="fw-bold mb-0" style="color: var(--text-main);">{{$studentsCount}}</h3>
                </div>
                <i class="fa-solid fa-arrow-up text-success fs-3"></i>
              </div>
            </a>
          </div>
          <div class="col-12">
            <a href="{{ route('teachers.index') }}" class="text-decoration-none d-block">
              <div class="custom-card d-flex justify-content-between align-items-center shadow-sm-hover"
                style="transition: transform 0.2s;">
                <div>
                  <p class="text-muted mb-1 fs-5">إجمالي المعلمين</p>
                  <h3 class="fw-bold mb-0" style="color: var(--text-main);">{{$teachersCount}}</h3>
                </div>
                <i class="fa-solid fa-arrow-down text-danger fs-3"></i>
              </div>
            </a>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="custom-card h-100">
          <div class="d-flex justify-content-between mb-4">
            <h5 class="fw-bold" style="color: var(--text-main);">مراقب المحتوى</h5>
            <i class="fa-solid fa-ellipsis text-muted"></i>
          </div>

          <ul class="list-unstyled d-flex flex-column gap-3">
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #4ade80;"></span>
              <span style="color: var(--text-main);">البلاغات</span>
            </li>
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #facc15;"></span>
              <span style="color: var(--text-main);">مشاكل تقنية</span>
            </li>
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #4ade80;"></span>
              <span style="color: var(--text-main);">المحتوى</span>
            </li>
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #4ade80;"></span>
              <span style="color: var(--text-main);">المحادثات</span>
            </li>
          </ul>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="custom-card h-100">
          <h5 class="fw-bold mb-4" style="color: var(--text-main);">طلبات الانضمام الأخيرة</h5>

          <a href="{{ route('requests.view', 'teacher') }}" class="text-decoration-none">
            <div class="d-flex align-items-center position-relative p-3 mb-3 rounded shadow-sm-hover"
              style="background-color: var(--bg-main); transition: transform 0.2s;">

              <div class="d-flex align-items-center gap-3">
                <div class="bg-secondary p-2 rounded text-white">
                  <i class="fa-regular fa-user"></i>
                </div>
                <div>
                  <h6 class="mb-0" style="color: var(--text-main);">طلبات المعلمين</h6>
                  <small class="text-muted">إجمالي الطلبات</small>
                </div>
              </div>

              <span class="position-absolute fw-bold"
                style="left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-main); font-size: 1.1rem;">
                {{ $pendingteachersCount }}
              </span>
            </div>
          </a>

          <a href="{{ route('requests.view', 'student') }}" class="text-decoration-none">
            <div class="d-flex align-items-center position-relative p-3 rounded shadow-sm-hover"
              style="background-color: var(--bg-main); transition: transform 0.2s;">

              <div class="d-flex align-items-center gap-3">
                <div class="bg-secondary p-2 rounded text-white">
                  <i class="fa-regular fa-user"></i>
                </div>
                <div>
                  <h6 class="mb-0" style="color: var(--text-main);">طلبات الطلاب</h6>
                  <small class="text-muted">إجمالي الطلبات</small>
                </div>
              </div>

              <span class="position-absolute fw-bold"
                style="left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-main); font-size: 1.1rem;">
                {{ $pendingstudentsCount }}
              </span>
            </div>
          </a>

        </div>
      </div>

    </div>

    <div class="row g-4 mb-4">

      <div class="col-lg-8">
        <div class="custom-card h-100 d-flex flex-column justify-content-center">
          <h5 class="fw-bold mb-4 text-center" style="color: var(--text-main);">تسجيل الطلاب حسب الشهر</h5>
          <canvas id="barChart" height="300"></canvas>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="custom-card h-100 d-flex flex-column justify-content-center">
          <h5 class="fw-bold mb-4 text-center" style="color: var(--text-main);">حالة الطلبات</h5>
          <canvas id="donutChart" height="200"></canvas>
        </div>
      </div>

    </div>

    <div class="row g-4 mb-4">
      <div class="col-12">
        <div class="custom-card">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0" style="color: var(--text-main);">سجل العمليات</h5>
            <a href="{{ route('logs.index') }}" class="btn btn-sm px-3"
              style="background-color: var(--hover-bg); color: var(--text-main); border: 1px solid var(--border-color); text-decoration: none;">
              عرض الكل
            </a>
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
  </div>
@endsection

@push('scripts')
  <script>
    Chart.defaults.color = '#9ca3af';
    Chart.defaults.borderColor = '#2d3748';


    const barCtx = document.getElementById('barChart').getContext('2d');
    new Chart(barCtx, {
      type: 'bar',
      data: {
        labels: @json($chartLabels),
        datasets: [
          {
            label: 'الطلاب',
            data: @json($studentsChartData),
            backgroundColor: '#3b82f6',
            borderRadius: 4,
            barPercentage: 0.6
          },
          {
            label: 'المعلمون',
            data: @json($teachersChartData),
            backgroundColor: '#10b981',
            borderRadius: 4,
            barPercentage: 0.6
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            display: true,
            position: 'top',
            labels: {
              usePointStyle: true
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1
            }
          }
        }
      }
    });

    const donutCtx = document.getElementById('donutChart').getContext('2d');
    new Chart(donutCtx, {
      type: 'doughnut',
      data: {
        labels: ['الطلاب', 'المعلمين'],
        datasets: [{
          data: [{{ $pendingstudentsCount ?? 0 }}, {{ $pendingteachersCount ?? 0 }}],
          backgroundColor: ['#3b82f6', '#8b5cf6', '#64748b'],
          borderWidth: 0
        }]
      },
      options: {
        responsive: true,
        cutout: '75%',
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              padding: 20,
              usePointStyle: true
            }
          }
        }
      }
    });
  </script>
@endpush