<header class="d-flex align-items-center justify-content-between p-3 border-bottom"
  style="background-color: var(--bg-card); border-color: var(--border-color) !important;">

  <div class="d-flex align-items-center gap-4">

    <div class="d-flex align-items-center gap-2" style="cursor: pointer;">
      <img src="https://ui-avatars.com/api/?name=Admin+User&background=2d3748&color=fff" alt="Admin"
        class="rounded-circle" width="40" height="40">
      <div class="d-flex flex-column lh-1">
        <span class="fw-bold" style="color: var(--text-main);">Admin User</span>
      </div>
      <i class="fa-solid fa-chevron-down ms-2" style="font-size: 0.8rem; color: var(--text-muted);"></i>
    </div>

    <div class="position-relative" style="cursor: pointer;">
      <i class="fa-regular fa-bell fs-5" style="color: #a3e635;"></i>
      <span class="position-absolute top-0 start-100 translate-middle p-1 bg-danger border border-light rounded-circle">
        <span class="visually-hidden">New alerts</span>
      </span>
    </div>

  </div>

  <div class="d-none d-md-flex">
    <div class="input-group" style="width: 300px;">
      <span class="input-group-text border-0" style="background-color: var(--bg-main); color: var(--text-muted);">
        <i class="fa-solid fa-magnifying-glass"></i>
      </span>

      <input type="text" class="form-control border-0 shadow-none search-input" placeholder="البحث">
    </div>
  </div>

</header>