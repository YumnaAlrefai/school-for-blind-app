@extends('layouts.app')

@section('content')
<div class="container-fluid p-0">
  <div class="row mb-4">
    <div class="col-12">
      <h4 class="fw-bold" style="color: var(--text-main);">قائمة المعلمين</h4>
    </div>
  </div>

  <div class="row">
    <div class="col-12">
      <div class="custom-card">
        @include('pages.teachers.partials.table', ['teachers' => $teachers])
        
        <div class="d-flex justify-content-center mt-4" dir="ltr">
          {{ $teachers->links() }}
        </div>
      </div>
    </div>
  </div>
</div>
@endsection