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
                    <i class="fa-regular fa-eye"></i> معاينة
                  </button>

                  <button class="btn btn-sm btn-success btn-quick-action" data-id="{{ $req->id }}"
                    data-type="{{ isset($req->fullname) ? 'student' : 'teacher' }}" data-action="approved">
                    قبول
                  </button>

                  <button class="btn btn-sm btn-danger btn-quick-action" data-id="{{ $req->id }}"
                    data-type="{{ isset($req->fullname) ? 'student' : 'teacher' }}" data-action="rejected">
                    رفض
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
        <div class="modal-body p-4" id="modal-body-content">
          <div class="text-center p-5">
            <i class="fa-solid fa-circle-notch fa-spin fs-1 text-muted"></i>
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
    function updateStatus(type, id, status) {
      fetch(`/request-update-status/${type}/${id}`, {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': '{{ csrf_token() }}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: JSON.stringify({ status: status })
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            alert(data.message);
            location.reload();
          }
        })
        .catch(error => console.error('Error:', error));
    }

    document.addEventListener('DOMContentLoaded', function () {
      let activeId = null;
      let activeType = null;

      document.querySelectorAll('.btn-view-details').forEach(button => {
        button.addEventListener('click', function () {
          activeId = this.getAttribute('data-id');
          activeType = this.getAttribute('data-type');

          const myModal = new bootstrap.Modal(document.getElementById('dynamicDetailsModal'));
          myModal.show();

          fetch(`/request-details/${activeType}/${activeId}`)
            .then(response => response.json())
            .then(data => {
              document.getElementById('modal-user-name').innerText = data.name;
              document.getElementById('modal-body-content').innerHTML = data.html;
            });
        });
      });

      document.getElementById('confirmAccept').addEventListener('click', function () {
        if (activeId) updateStatus(activeType, activeId, 'approved');
      });

      document.getElementById('confirmReject').addEventListener('click', function () {
        if (activeId) updateStatus(activeType, activeId, 'rejected');
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