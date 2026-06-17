<div class="d-flex flex-column h-100 p-3" style="color: var(--text-main);">

  <a href="/" class="d-flex align-items-center mb-4 text-decoration-none justify-content-between"
    style="color: var(--text-main);">
    <span class="fs-4 fw-bold">SESB</span>
    <i class="fa-regular fa-face-laugh-beam fs-2" style="color: #a3e635;"></i>
  </a>

  <hr style="border-color: var(--border-color);">

  <ul class="nav nav-pills flex-column mb-auto gap-2">

    <li class="nav-item">
      <a href="{{ route('dashboard') }}"
        class="nav-link d-flex align-items-center justify-content-between {{ request()->routeIs('dashboard') ? 'nav-link-active' : 'nav-link-custom' }}">
        <span class="fw-bold">لوحة القيادة</span>
        <i class="fa-solid fa-gauge-high"></i>
      </a>
    </li>

    <li class="nav-item mt-3 mb-1 px-3" style="color: var(--text-muted); font-size: 0.85rem;">اقسام</li>

    {{-- قسم طلبات الانضمام --}}
    <li class="nav-item">
      <a class="nav-link d-flex align-items-center justify-content-between cursor-pointer {{ request()->routeIs('requests.view') ? 'nav-link-active' : 'nav-link-custom' }}"
        data-bs-toggle="collapse" href="#requestsDropdown" role="button">

        <span>طلبات الانضمام</span>

        <i class="fa-solid fa-users-gear"></i>
      </a>

      <div class="collapse {{ request()->routeIs('requests.view') ? 'show' : '' }}" id="requestsDropdown">
        <ul class="nav flex-column me-4 mt-2 gap-1"
          style="border-right: 1px solid var(--border-color); padding-right: 15px;">
          <li class="nav-item">
            <a href="{{ route('requests.view', 'student') }}"
              class="nav-link py-2 {{ request()->is('requests/student') ? 'fw-bold text-success' : 'text-muted' }}"
              style="font-size: 0.9rem;">
              طلبات الطلاب
            </a>
          </li>
          <li class="nav-item">
            <a href="{{ route('requests.view', 'teacher') }}"
              class="nav-link py-2 {{ request()->is('requests/teacher') ? 'fw-bold text-success' : 'text-muted' }}"
              style="font-size: 0.9rem;">
              طلبات الأساتذة
            </a>
          </li>
        </ul>
      </div>
    </li>

    {{-- قسم المستخدمين (الجديد) --}}
    <li class="nav-item">
      <a class="nav-link d-flex align-items-center justify-content-between cursor-pointer {{ request()->routeIs('students.index', 'teachers.index') ? 'nav-link-active' : 'nav-link-custom' }}"
        data-bs-toggle="collapse" href="#usersDropdown" role="button">

        <span>المستخدمون</span>

        <i class="fa-solid fa-users"></i>
      </a>

      <div class="collapse {{ request()->routeIs('students.index', 'teachers.index') ? 'show' : '' }}" id="usersDropdown">
        <ul class="nav flex-column me-4 mt-2 gap-1"
          style="border-right: 1px solid var(--border-color); padding-right: 15px;">
          <li class="nav-item">
            <a href="{{ route('students.index') }}"
              class="nav-link py-2 {{ request()->routeIs('students.index') ? 'fw-bold text-success' : 'text-muted' }}"
              style="font-size: 0.9rem;">
              كل الطلاب
            </a>
          </li>
          <li class="nav-item">
            <a href="{{ route('teachers.index') }}"
              class="nav-link py-2 {{ request()->routeIs('teachers.index') ? 'fw-bold text-success' : 'text-muted' }}"
              style="font-size: 0.9rem;">
              كل الأساتذة
            </a>
          </li>
        </ul>
      </div>
    </li>

    <li>
      <a href="{{ route('content.monitor') }}"
        class="nav-link d-flex align-items-center justify-content-between {{ request()->routeIs('content.monitor') ? 'nav-link-active' : 'nav-link-custom' }}">
        <span>مراقب المحتوى</span>
        <i class="fa-solid fa-shield-halved"></i>
      </a>
    </li>

    <li class="nav-item mt-3 mb-1 px-3" style="color: var(--text-muted); font-size: 0.85rem;">اضافي</li>

    <li>
      <a href="{{ route('classes') }}"
        class="nav-link d-flex align-items-center justify-content-between {{ request()->routeIs('classes') ? 'nav-link-active' : 'nav-link-custom' }}">
        <span>صفوفنا</span>
        <i class="fa-regular fa-folder-open"></i>
      </a>
    </li>

    <li>
      <a href="{{ route('charts') }}"
        class="nav-link d-flex align-items-center justify-content-between {{ request()->routeIs('charts') ? 'nav-link-active' : 'nav-link-custom' }}">
        <span>مخططات بيانية</span>
        <i class="fa-solid fa-chart-line"></i>
      </a>
    </li>

    <li>
      <a href="{{ route('logs.index') }}"
        class="nav-link d-flex align-items-center justify-content-between {{ request()->routeIs('logs.index') ? 'nav-link-active' : 'nav-link-custom' }}">
        <span>سجلاتنا</span>
        <i class="fa-solid fa-table-list"></i>
      </a>
    </li>

  </ul>

  <hr style="border-color: var(--border-color);">

  <div class="d-flex align-items-center px-3 pb-2 mt-2">
    <div class="form-check form-switch" style="transform: scale(1.4); transform-origin: right;">
      <input class="form-check-input" type="checkbox" role="switch" id="themeSwitch" onclick="toggleTheme()" checked
        style="background-color: #a3e635; border-color: #a3e635; cursor: pointer;">
    </div>
  </div>

</div>