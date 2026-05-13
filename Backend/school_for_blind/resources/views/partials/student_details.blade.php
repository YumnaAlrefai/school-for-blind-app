<div class="row g-4">
    <div class="col-md-6">
        <label class="text-muted small d-block">اسم الأب</label>
        <h6 class="fw-bold" style="color: var(--text-main);">{{ $user->fathersname }}</h6>
    </div>
    <div class="col-md-6">
        <label class="text-muted small d-block">رقم ولي الأمر</label>
        <h6 class="fw-bold" style="color: var(--text-main);">{{ $user->parent_phone }}</h6>
    </div>
    <div class="col-md-6">
        <label class="text-muted small d-block">المستوى الدراسي</label>
        <span class="badge bg-primary">{{ $user->level == 'twelfth' ? 'بكالوريا' : 'تاسع' }}</span>
    </div>
    <div class="col-md-6">
        <label class="text-muted small d-block">النقاط</label>
        <h6 class="text-success fw-bold">{{ $user->points }} نقطة</h6>
    </div>
    <div class="col-12">
        <label class="text-muted small d-block mb-2">الوثائق الثبوتية</label>
        <a href="{{ asset('storage/' . $user->DocumentaryEvidence) }}" target="_blank" class="btn btn-sm btn-outline-info w-100">
            <i class="fa-solid fa-file-pdf ms-2"></i> عرض الوثيقة المرفقة
        </a>
    </div>
</div>