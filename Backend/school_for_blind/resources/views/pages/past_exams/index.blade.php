@extends('layouts.app') {{-- تأكد من اسم الـ layout الخاص بالداشبورد عندك --}}

@section('content')
<div class="container-fluid py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold" style="color: var(--text-main);">الدورات الوزارية السابقة</h2>
        <a href="{{ route('dashboard.past-exams.create') }}" class="btn btn-accept px-4 rounded-pill">
            <i class="fa-solid fa-plus me-2"></i> إضافة دورة جديدة
        </a>
    </div>

    {{-- قسم البحث والفلترة --}}
    <div class="custom-card mb-4 p-3">
        <form action="{{ route('dashboard.past-exams.index') }}" method="GET" class="row g-3 align-items-center">
            
            <div class="col-md-4">
                <input type="text" name="search" class="form-control search-input rounded-pill" 
                       placeholder="ابحث باسم الدورة..." value="{{ request('search') }}">
            </div>
            
            <div class="col-md-3">
                <select name="subject_id" class="form-select search-input rounded-pill">
                    <option value="">كل المواد</option>
                    @foreach($subjects as $subject)
                        <option value="{{ $subject->id }}" {{ request('subject_id') == $subject->id ? 'selected' : '' }}>
                            {{ $subject->name }}
                        </option>
                    @endforeach
                </select>
            </div>
            
            <div class="col-md-3">
                <select name="year" class="form-select search-input rounded-pill">
                    <option value="">كل السنوات</option>
                    @for($i = date('Y'); $i >= 2010; $i--)
                        <option value="{{ $i }}" {{ request('year') == $i ? 'selected' : '' }}>{{ $i }}</option>
                    @endfor
                </select>
            </div>
            
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100 rounded-pill">
                    <i class="fa-solid fa-magnifying-glass me-1"></i> تصفية
                </button>
            </div>
        </form>
    </div>

    {{-- جدول عرض الدورات --}}
    <div class="custom-card p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-hover-custom mb-0 text-center" style="color: var(--text-main); border-color: var(--border-color);">
                <thead style="background-color: var(--hover-bg);">
                    <tr>
                        <th class="py-3">#</th>
                        <th class="py-3">عنوان الدورة</th>
                        <th class="py-3">المادة</th>
                        <th class="py-3">السنة والدورة</th>
                        <th class="py-3">الحالة</th>
                        <th class="py-3">الإجراءات</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($pastExams as $exam)
                        <tr>
                            <td class="align-middle">{{ $loop->iteration }}</td>
                            <td class="align-middle fw-bold">{{ $exam->title }}</td>
                            <td class="align-middle">{{ $exam->subject->name ?? 'غير محدد' }}</td>
                            <td class="align-middle">
                                {{ $exam->year }} - 
                                @if($exam->session == 'first') الأولى
                                @elseif($exam->session == 'second') الثانية
                                @else تكميلية @endif
                            </td>
                            <td class="align-middle">
                                @if($exam->is_published)
                                    <span class="badge-status bg-soft-success">منشورة</span>
                                @else
                                    <span class="badge-status bg-soft-warning">مسودة</span>
                                @endif
                            </td>
                            <td class="align-middle">
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="{{ route('dashboard.past-exams.show', $exam->id) }}" class="btn btn-sm btn-info text-white" title="عرض وإدارة الأسئلة">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="{{ route('dashboard.past-exams.edit', $exam->id) }}" class="btn btn-sm btn-primary" title="تعديل">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <form action="{{ route('dashboard.past-exams.destroy', $exam->id) }}" method="POST" class="d-inline" onsubmit="return confirm('هل أنت متأكد من حذف هذه الدورة؟');">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-sm btn-reject" title="حذف">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-4 text-muted">لا يوجد دورات سابقة مضافة حالياً.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        
        {{-- روابط التقليب بين الصفحات (Pagination) --}}
        @if($pastExams->hasPages())
            <div class="d-flex justify-content-center p-3 border-top" style="border-color: var(--border-color) !important;">
                {{ $pastExams->links() }}
            </div>
        @endif
    </div>

</div>
@endsection