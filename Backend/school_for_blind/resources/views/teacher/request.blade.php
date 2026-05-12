@extends('layouts.app')
@section('content')
  <div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">طلبات الأساتذة</h1>
    <p>هذه الصفحة مخصصة لعرض وإدارة طلبات الأساتذة.</p>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">قائمة الطلبات الجديدة</h6>
      </div>
      <div class="card-body">
        <div class="table-responsive">

          <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>الرقم</th>
                <th>اسم الأستاذ</th>
                <th>رقم الهاتف</th>
                <th>تاريخ الطلب</th>
                <th>الحالة</th>
              </tr>
            </thead>

            <tbody>
              @foreach($teachers as $teacher)
                <tr>
                  <td>{{ $teacher->id }}</td>
                  <td>{{ $teacher->full_name }}</td>
                  <td>{{ $teacher->phone }}</td>
                  <td>{{ $teacher->created_at->format('Y-m-d') }}</td>
                  <td>{{ $teacher->status }}</td>

                  {{-- 6. أزرار التحكم --}}
                  {{-- <td>
                    <a href="{{ route('teacher.edit', $teacher->id) }}" class="btn btn-primary btn-sm">
                      <i class="fas fa-edit"></i> عرض وتعديل
                    </a>
                  </td> --}}
                </tr>
              @endforeach
            </tbody>
          </table>

        </div>
      </div>
    </div>
  </div>


@endsection