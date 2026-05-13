@extends('layouts.app')

@section('content')
  <div class="container-fluid p-0">

    <div class="row g-4 mb-4">

      <div class="col-lg-4">
        <div class="row g-3">
          <div class="col-12">
            <div class="custom-card d-flex justify-content-between align-items-center">
              <div>
                <p class="text-muted mb-1 fs-5">إجمالي الطلاب</p>
                <h3 class="fw-bold mb-0" style="color: var(--text-main);">{{$studentsCount}}</h3>
              </div>
              <i class="fa-solid fa-arrow-up text-success fs-3"></i>
            </div>
          </div>
          <div class="col-12">
            <div class="custom-card d-flex justify-content-between align-items-center">
              <div>
                <p class="text-muted mb-1 fs-5">إجمالي المعلمين</p>
                <h3 class="fw-bold mb-0" style="color: var(--text-main);">{{$teachersCount}}</h3>
              </div>
              <i class="fa-solid fa-arrow-down text-danger fs-3"></i>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="custom-card h-100">
          <div class="d-flex justify-content-between mb-4">
            <h5 class="fw-bold" style="color: var(--text-main);">مراقب المحتوى: التنبيهات</h5>
            <i class="fa-solid fa-ellipsis text-muted"></i>
          </div>

          <ul class="list-unstyled d-flex flex-column gap-3">
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #4ade80;"></span>
              <span style="color: var(--text-main);">مراقب المحتوى: التنبيهات</span>
            </li>
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #facc15;"></span>
              <span style="color: var(--text-main);">محلات التنبيهات</span>
            </li>
            <li class="d-flex align-items-center">
              <span class="p-2 rounded-circle me-3" style="background-color: #4ade80;"></span>
              <span style="color: var(--text-main);">نشاط المحتوى</span>
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
        <div class="custom-card">
          <h5 class="fw-bold mb-4 text-center" style="color: var(--text-main);">تسجيل الطلاب حسب الشهر</h5>
          <canvas id="barChart" height="100"></canvas>
        </div>
      </div>
      <div class="col-lg-4">
        <div class="custom-card">
          <h5 class="fw-bold mb-4 text-center" style="color: var(--text-main);">حالة الطلبات</h5>
          <canvas id="donutChart" height="200"></canvas>
        </div>
      </div>
    </div>

    <div class="row g-4 mb-4">
      <div class="col-12">
        <div class="custom-card">
          <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0" style="color: var(--text-main);">سجلاتنا</h5>
            <button class="btn btn-sm px-3"
              style="background-color: var(--hover-bg); color: var(--text-main); border: 1px solid var(--border-color);">عرض
              الكل</button>
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
                <tr style="border-bottom: 1px solid var(--border-color);">
                  <td class="py-3">
                    <div class="d-flex align-items-center">
                      <div class="rounded-circle bg-soft-info p-2 me-2 d-flex align-items-center justify-content-center"
                        style="width: 35px; height: 35px;">
                        <i class="fa-solid fa-file-signature fs-6"></i>
                      </div>
                      <span>محددة الأنسائك التعقيبية</span>
                    </div>
                  </td>
                  <td class="py-3 text-muted">مطبعة عدن المعلمين</td>
                  <td class="py-3">
                    <span class="badge-status bg-soft-info">6/36 في</span>
                  </td>
                  <td class="py-3 text-muted text-start">2023-10-15</td>
                </tr>

                <tr style="border-bottom: 1px solid var(--border-color);">
                  <td class="py-3">
                    <div class="d-flex align-items-center">
                      <div
                        class="rounded-circle bg-soft-success p-2 me-2 d-flex align-items-center justify-content-center"
                        style="width: 35px; height: 35px;">
                        <i class="fa-solid fa-user-check fs-6"></i>
                      </div>
                      <span>تحديث بيانات الطلاب</span>
                    </div>
                  </td>
                  <td class="py-3 text-muted">قسم التسجيل</td>
                  <td class="py-3">
                    <span class="badge-status bg-soft-success">ناجح</span>
                  </td>
                  <td class="py-3 text-muted text-start">2023-10-14</td>
                </tr>

                <tr>
                  <td class="py-3">
                    <div class="d-flex align-items-center">
                      <div
                        class="rounded-circle bg-soft-warning p-2 me-2 d-flex align-items-center justify-content-center"
                        style="width: 35px; height: 35px;">
                        <i class="fa-solid fa-user-plus fs-6"></i>
                      </div>
                      <span>إضافة معلم جديد</span>
                    </div>
                  </td>
                  <td class="py-3 text-muted">الموارد البشرية</td>
                  <td class="py-3">
                    <span class="badge-status bg-soft-warning">قيد الانتظار</span>
                  </td>
                  <td class="py-3 text-muted text-start">2023-10-13</td>
                </tr>
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
        labels: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'],
        datasets: [{
          label: 'عدد الطلاب',
          data: [1200, 1900, 1500, 2200, 1800, 2500],
          backgroundColor: '#3b82f6',
          borderRadius: 6,
          barPercentage: 0.5
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    });

    const donutCtx = document.getElementById('donutChart').getContext('2d');
    new Chart(donutCtx, {
      type: 'doughnut',
      data: {
        labels: ['الطلاب', 'المعلمين', 'أخرى'],
        datasets: [{
          data: [60, 30, 10],
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