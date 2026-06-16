@extends('layouts.app')

@section('content')
<div class="container-fluid py-4">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="custom-card p-4 shadow-sm" style="background-color: var(--bg-card); border-radius: 15px; border: 1px solid var(--border-color);">
                <h4 class="fw-bold mb-4" style="color: var(--text-main);"><i class="fa-solid fa-user-gear me-2"></i> {{ $title }}</h4>
                <hr style="border-color: var(--border-color);">

                <form action="{{ route('teachers.approve.submit', $teacher->id) }}" method="POST">
                    @csrf

                    <h5 class="fw-bold mb-3 mt-4" style="color: var(--text-main);">1. البيانات الأساسية</h5>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label" style="color: var(--text-main);">الاسم الكامل</label>
                            <input type="text" name="full_name" class="form-control @error('full_name') is-invalid @enderror" value="{{ old('full_name', $teacher->full_name) }}" style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color);">
                            @error('full_name') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" style="color: var(--text-main);">رقم الهاتف</label>
                            <input type="text" name="phone" class="form-control @error('phone') is-invalid @enderror" value="{{ old('phone', $teacher->phone) }}" style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color);">
                            @error('phone') <div class="invalid-feedback">{{ $message }}</div> @enderror
                        </div>

                        <div class="col-md-6">
                            <label class="form-label" style="color: var(--text-main);">المرحلة الدراسية</label>
                            <select name="level" class="form-select" style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color);">
                                <option value="ninth" {{ old('level', $teacher->level) == 'ninth' ? 'selected' : '' }}>تاسع (Ninth)</option>
                                <option value="twelfth" {{ old('level', $teacher->level) == 'twelfth' ? 'selected' : '' }}>بكالوريا (Twelfth)</option>
                            </select>
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3 mt-5" style="color: var(--text-main);">2. الشعب والصفوف المسندة</h5>
                    <p class="text-muted small">تأكيد الشعب المحددة مسبقاً (يمكنك التعديل عليها هنا أيضاً):</p>
                    <div class="row">
                        <div class="col-12">
                            <select name="classes[]" class="form-select" multiple style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color); min-height: 120px;">
                                @foreach($allClasses as $class)
                                    <option value="{{ $class->id }}" {{ in_array($class->id, old('classes', $selectedClassIds)) ? 'selected' : '' }}>
                                        {{ $class->level }} - {{ $class->name }}
                                    </option>
                                @endforeach
                            </select>
                            <small class="text-muted mt-1 d-block">💡 اضغط مستمراً على Ctrl أو Cmd لاختيار صفوف متعددة.</small>
                        </div>
                    </div>

                    <h5 class="fw-bold mb-3 mt-5" style="color: var(--text-main);">3. تحديد المواد وأسعار الحصص</h5>
                    <p class="text-muted small">قم بتفعيل المادة ثم أدخل السعر الخاص بها للأستاذ:</p>
                    
                    <div class="table-responsive mt-3">
                        <table class="table table-bordered align-middle text-center" style="color: var(--text-main); border-color: var(--border-color);">
                            <thead style="background-color: var(--bg-main);">
                                <tr>
                                    <th style="width: 10%;">تفعيل</th>
                                    <th style="width: 45%;" class="text-start">اسم المادة</th>
                                    <th style="width: 45%;">سعر الدرس للأستاذ (بالعملة المحلية)</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($subjects as $subject)
                                <tr>
                                    <td>
                                        <input type="checkbox" name="subjects[]" value="{{ $subject->id }}" 
                                               id="subject_{{ $subject->id }}" class="form-check-input subject-checkbox"
                                               {{ is_array(old('subjects')) && in_array($subject->id, old('subjects')) ? 'checked' : '' }}>
                                    </td>
                                    <td class="text-start">
                                        <label for="subject_{{ $subject->id }}" class="form-check-label fw-semibold" style="cursor:pointer;">
                                            {{ $subject->name }} <span class="badge bg-secondary ms-2">{{ $subject->grade_level }}</span>
                                        </label>
                                    </td>
                                    <td>
                                        <div class="input-group justify-content-center mx-auto" style="max-width: 250px;">
                                            <input type="number" name="prices[{{ $subject->id }}]" 
                                                   id="price_{{ $subject->id }}" class="form-control price-input text-center" 
                                                   value="{{ old('prices.'.$subject->id, 0) }}" min="0" placeholder="0" disabled
                                                   style="background-color: var(--bg-main); color: var(--text-main); border-color: var(--border-color);">
                                        </div>
                                    </td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                    @error('subjects') <div class="text-danger small mt-1">{{ $message }}</div> @enderror

                    <div class="d-flex gap-3 mt-5">
                        <button type="submit" class="btn btn-success px-5 py-3 fw-bold shadow-sm"><i class="fa-solid fa-check me-2"></i> اعتماد وتثبيت قبول الأستاذ</button>
                        <a href="{{ url()->previous() }}" class="btn btn-secondary px-4 py-3 fw-bold">إلغاء التنشيط والعودة</a>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function () {
        function togglePriceInput(checkbox) {
            const priceInput = document.getElementById('price_' + checkbox.value);
            if (priceInput) {
                if (checkbox.checked) {
                    priceInput.removeAttribute('disabled');
                    priceInput.style.backgroundColor = 'transparent';
                } else {
                    priceInput.setAttribute('disabled', 'disabled');
                    priceInput.value = 0;
                    priceInput.style.backgroundColor = 'var(--bg-main)';
                }
            }
        }

        document.querySelectorAll('.subject-checkbox').forEach(checkbox => {
            togglePriceInput(checkbox);
            
            checkbox.addEventListener('change', function() {
                togglePriceInput(this);
            });
        });
    });
</script>
@endpush