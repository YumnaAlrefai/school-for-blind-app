@extends('layouts.app')

@section('content')
  <div class="container-fluid">
    <div class="custom-card">
      <h4 class="fw-bold mb-4" style="color: var(--text-main);">{{ $title }}</h4>

      <div class="table-responsive">
        <table class="table table-hover align-middle" style="color: var(--text-main);">
          <thead class="text-muted">
            <tr>
              <th>الأسم</th>
              <th>التاريخ</th>
              <th>الحالة</th>
              <th>إجراءات</th>
            </tr>
          </thead>
          <tbody>
            @foreach($requests as $req)
              <tr>
                <td>{{ $req->fullname ?? $req->full_name }}</td>
                <td>{{ $req->created_at->format('Y-m-d') }}</td>
                <td><span class="badge bg-soft-warning">قيد الانتظار</span></td>
                <td>
                  <button class="btn btn-sm btn-info btn-view-details text-white" data-id="{{ $req->id }}"
                    data-type="{{ isset($req->fullname) ? 'student' : 'teacher' }}">
                    <i class="fa-regular fa-eye"></i> معاينة وقبول
                  </button>

                  <button class="btn btn-sm btn-danger btn-quick-action" data-id="{{ $req->id }}"
                    data-type="{{ isset($req->fullname) ? 'student' : 'teacher' }}" data-action="rejected">
                    رفض السجل
                  </button>
                </td>
              </tr>
            @endforeach
          </tbody>
        </table>
      </div>

      <div class="mt-4">
        {{ $requests->links() }}
      </div>
    </div>
  </div>

  <div class="modal fade glass-modal" id="dynamicDetailsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content"
        style="background-color: var(--bg-card); border-radius: 20px; border: 1px solid var(--border-color);">
        <div class="modal-header border-0 p-4">
          <div>
            <h4 class="fw-bold mb-0" id="modal-user-name" style="color: var(--text-main);">جاري التحميل...</h4>
            <span id="modal-user-type" class="badge bg-soft-info mt-2"></span>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>

        <div class="modal-body p-4">
          <div id="modal-body-content">
            <div class="text-center p-5">
              <i class="fa-solid fa-circle-notch fa-spin fs-1 text-muted"></i>
            </div>
          </div>

          <div id="classSelectionWrapper" class="mt-4 pt-3 border-top d-none">
            <label id="classSelectLabel" class="form-label fw-bold" style="color: var(--text-main);"></label>
            <select id="modal_class_id" class="form-select"
              style="background-color: var(--bg-card); color: var(--text-main); border-color: var(--border-color); min-height: 45px;">
              <option value="">-- اختر الشعبة --</option>
              @foreach($classes as $class)
                <option value="{{ $class->id }}" data-level="{{ $class->level }}">
                  {{ $class->level }} - {{ $class->name }}
                </option>
              @endforeach
            </select>
            <small id="classSelectionHint" class="text-muted d-none mt-2 d-block">💡 يمكنك اختيار أكثر من شعبة بالضغط
              المستمر على زر <b>Ctrl</b> في الويندوز أو <b>Cmd</b> في الماك أثناء الضغط على الخيارات.</small>
          </div>
        </div>

        <div class="modal-footer border-0 p-4">
          <div class="d-flex gap-2 w-100">
            <button id="confirmAccept" class="btn btn-success flex-grow-1 py-3 fw-bold shadow-sm">تأكيد القبول</button>
            <button id="confirmReject" class="btn btn-danger flex-grow-1 py-3 fw-bold shadow-sm">رفض نهائي</button>
          </div>
        </div>
      </div>
    </div>
  </div>
@endsection

@push('scripts')
  <script>
    document.addEventListener('DOMContentLoaded', function () {
      let activeId = null;
      let activeType = null;

      const classSelect = document.getElementById('modal_class_id');
      const classWrapper = document.getElementById('classSelectionWrapper');
      const classLabel = document.getElementById('classSelectLabel');
      const classHint = document.getElementById('classSelectionHint');

      function updateStatus(type, id, status) {
        let classId = null;

        if (status === 'approved') {
          if (type === 'teacher') {
            classId = Array.from(classSelect.selectedOptions).map(option => option.value).filter(val => val !== "");
            if (classId.length === 0) {
              alert('الرجاء تحديد شعبة واحدة على الأقل للأستاذ');
              return;
            }
          } else {
            classId = classSelect.value;
            if (!classId) {
              alert('الرجاء تحديد الشعبة الخاصة بالطالب أولاً');
              return;
            }
          }
        }

        fetch(`/request-update-status/${type}/${id}`, {
          method: 'POST',
          headers: {
            'X-CSRF-TOKEN': '{{ csrf_token() }}',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: JSON.stringify({
            status: status,
            class_id: classId
          })
        })
          .then(async response => {
            const isJson = response.headers.get('content-type')?.includes('application/json');
            const data = isJson ? await response.json() : null;

            if (!response.ok) {
              const errorMsg = (data && data.message) ? data.message : 'خطأ في السيرفر (Status: ' + response.status + ')';
              return Promise.reject(errorMsg);
            }
            return data;
          })
          .then(data => {
            if (data.success) {
              alert(data.message);
              location.reload();
            }
          })
          .catch(error => {
            console.error('Error Details:', error);
            alert('فشل الإجراء: ' + error);
          });
      }

      // عند الضغط على زر "معاينة وقبول" من الجدول
      document.querySelectorAll('.btn-view-details').forEach(button => {
        button.addEventListener('click', function () {
          activeId = this.getAttribute('data-id');
          activeType = this.getAttribute('data-type');

          // إعادة تهيئة واجهة القائمة المنسدلة للشعب
          classSelect.value = '';
          classWrapper.classList.remove('d-none');

          // تحويل الـ Select ديناميكياً بناءً على نوع مقدم الطلب
          if (activeType === 'teacher') {
            classSelect.setAttribute('multiple', 'multiple');
            classSelect.style.height = 'auto';
            classLabel.innerText = 'حدد الشعب التي سيقوم الأستاذ بتدريسها:';
            classHint.classList.remove('d-none');
          } else {
            classSelect.removeAttribute('multiple');
            classSelect.style.height = '45px';
            classLabel.innerText = 'حدد الشعبة التي سينضم إليها الطالب:';
            classHint.classList.add('d-none');
          }

          const myModal = new bootstrap.Modal(document.getElementById('dynamicDetailsModal'));
          myModal.show();

          // جلب تفاصيل الشخص عبر الـ AJAX
          fetch(`/request-details/${activeType}/${activeId}`)
            .then(response => response.json())
            .then(data => {
              document.getElementById('modal-user-name').innerText = data.name;
              document.getElementById('modal-user-type').innerText = data.type_label;
              document.getElementById('modal-body-content').innerHTML = data.html;

              // 💡 بداية منطق الفلترة الذكية بناءً على اللفل
              const userLevel = data.level; // اللفل القادم من السيرفر (مثلاً Grade 1)

              Array.from(classSelect.options).forEach(option => {
                // إبقاء الخيار الافتراضي "-- اختر الشعبة --" ظاهراً دائماً
                if (option.value === "") {
                  option.style.display = "block";
                  return;
                }

                // قراءة لفل الشعبة ومقارنته بلفل المستخدم
                const classLevel = option.getAttribute('data-level');

                if (classLevel === userLevel) {
                  option.style.display = "block";  // إظهار الشعبة المتطابقة
                  option.disabled = false;
                } else {
                  option.style.display = "none";   // إخفاء الشعبة غير المتطابقة
                  option.disabled = true;          // تعطيلها لضمان عدم إرسالها بالخطأ
                }
              });
            });
        });
      });

      document.getElementById('confirmAccept').addEventListener('click', function () {
        if (activeId) updateStatus(activeType, activeId, 'approved');
      });

      document.getElementById('confirmReject').addEventListener('click', function () {
        if (activeId && confirm('هل أنت متأكد من الرفض النهائي لهذا الطلب؟')) {
          updateStatus(activeType, activeId, 'rejected');
        }
      });

      document.querySelectorAll('.btn-quick-action').forEach(button => {
        button.addEventListener('click', function () {
          const id = this.getAttribute('data-id');
          const type = this.getAttribute('data-type');
          const action = this.getAttribute('data-action');

          if (confirm('هل أنت متأكد من تنفيذ هذا الإجراء؟')) {
            updateStatus(type, id, action);
          }
        });
      });
    });
  </script>
@endpush