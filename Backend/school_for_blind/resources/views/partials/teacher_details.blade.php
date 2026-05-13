<div class="row g-4">
    <div class="col-md-6">
        <label class="text-muted small d-block">المواد التي يدرسها</label>
        <h6 class="fw-bold" style="color: var(--text-main);">{{ $user->subjects }}</h6>
    </div>
    <div class="col-md-6">
        <label class="text-muted small d-block">المستوى المستهدف</label>
        <span class="badge bg-info">{{ $user->level == 'twelfth' ? 'بكالوريا' : 'تاسع' }}</span>
    </div>
    <div class="col-md-6">
        <label class="text-muted small d-block">رقم الهاتف</label>
        <h6 class="fw-bold" dir="ltr" style="color: var(--text-main);">{{ $user->phone }}</h6>
    </div>
    <div class="col-12">
        <label class="text-muted small d-block mb-2">السيرة الذاتية (CV)</label>
        <a href="{{ asset('storage/' . $user->cv_path) }}" target="_blank" class="btn btn-sm btn-outline-warning w-100">
            <i class="fa-solid fa-id-card ms-2"></i> تحميل السيرة الذاتية
        </a>
    </div>
</div>