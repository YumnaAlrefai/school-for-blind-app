<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title> SESB - تسجيل الدخول</title>
  <style>
    /* --- DESIGN SYSTEM & CSS VARIABLES --- */
    :root {
      /* Light Mode Palette */
      --bg-color: #F3F6F9;
      --card-bg: #FFFFFF;
      --text-primary: #1F2937;
      --text-secondary: #6B7280;
      --border-color: #E5E7EB;

      /* Accessibility Accents */
      --primary-accent: #2563EB;
      /* Solid blue for buttons */
      --focus-ring: 0 0 0 4px rgba(37, 99, 235, 0.5);
      --success-green: #22C55E;
      /* Vibrant logo green */

      /* Sizing & Radius */
      --radius-md: 8px;
      --radius-lg: 12px;
      --shadow-card: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
      --transition: all 0.2s ease-in-out;
    }

    /* --- DARK MODE PALETTE --- */
    .dark-mode {
      --bg-color: #111827;
      /* Deep Navy */
      --card-bg: #1F2937;
      /* Slightly lighter slate */
      --text-primary: #FFFFFF;
      --text-secondary: #9CA3AF;
      --border-color: #374151;

      --primary-accent: #3B82F6;
      /* Brighter blue for contrast */
      --focus-ring: 0 0 0 4px rgba(59, 130, 246, 0.6);

      --shadow-card: 0 10px 15px -3px rgba(0, 0, 0, 0.3), 0 4px 6px -2px rgba(0, 0, 0, 0.2);
    }

    /* --- BASE STYLES --- */
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: system-ui, -apple-system, sans-serif;
    }

    body {
      background-color: var(--bg-color);
      color: var(--text-primary);
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 20px;
      transition: var(--transition);
    }

    /* --- ACCESSIBILITY HELPER --- */
    .sr-only {
      position: absolute;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      white-space: nowrap;
      border-width: 0;
    }

    /* --- LOGIN CONTAINER --- */
    .login-card {
      background-color: var(--card-bg);
      padding: 40px;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-card);
      width: 100%;
      max-width: 480px;
      transition: var(--transition);
      text-align: center;
    }

    /* --- LOGO & HEADER --- */
    .brand-header {
      margin-bottom: 30px;
    }

    .logo-placeholder {
      width: 80px;
      height: 80px;
      background-color: var(--success-green);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 40px;
      color: white;
      margin: 0 auto 15px;
    }

    .main-heading {
      font-size: 28px;
      font-weight: 800;
      margin-bottom: 8px;
    }

    .sub-heading {
      font-size: 16px;
      color: var(--text-secondary);
      margin-bottom: 30px;
    }

    /* --- FORM STYLES --- */
    .form-group {
      margin-bottom: 20px;
      text-align: right;
      /* Consistent RTL */
    }

    .form-label {
      display: block;
      font-weight: 600;
      font-size: 14px;
      margin-bottom: 8px;
      color: var(--text-primary);
    }

    .input-wrapper {
      position: relative;
    }

    .form-input {
      width: 100%;
      padding: 14px 16px;
      font-size: 16px;
      border: 2px solid var(--border-color);
      border-radius: var(--radius-md);
      background-color: var(--card-bg);
      color: var(--text-primary);
      transition: var(--transition);
    }

    /* CRUCIAL: Accessible Focus States */
    .form-input:focus {
      outline: none;
      border-color: var(--primary-accent);
      box-shadow: var(--focus-ring);
    }

    /* Large input size for touch/low-vision */
    .form-input::placeholder {
      color: var(--text-secondary);
      opacity: 0.7;
    }

    /* --- BUTTONS --- */
    .submit-btn {
      width: 100%;
      padding: 16px;
      background-color: var(--primary-accent);
      color: white;
      border: none;
      border-radius: var(--radius-md);
      font-size: 18px;
      font-weight: 700;
      cursor: pointer;
      transition: var(--transition);
      margin-top: 10px;
    }

    .submit-btn:hover {
      opacity: 0.9;
    }

    /* Accessible Focus State for Button */
    .submit-btn:focus {
      outline: none;
      box-shadow: var(--focus-ring);
    }

    /* --- MODE TOGGLE (Fixed Top Right) --- */
    .theme-switch-wrapper {
      position: fixed;
      top: 20px;
      left: 20px;
      /* Adjusted for RTL layout comfort */
      display: flex;
      align-items: center;
      gap: 10px;
      background: var(--card-bg);
      padding: 10px 15px;
      border-radius: 50px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .theme-label {
      font-size: 14px;
      color: var(--text-secondary);
    }

    .theme-switch {
      position: relative;
      display: inline-block;
      width: 50px;
      height: 26px;
    }

    .theme-switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: #ccc;
      transition: .4s;
      border-radius: 34px;
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 4px;
      bottom: 4px;
      background-color: white;
      transition: .4s;
      border-radius: 50%;
    }

    input:checked+.slider {
      background-color: var(--primary-accent);
    }

    input:focus+.slider {
      box-shadow: var(--focus-ring);
    }

    input:checked+.slider:before {
      transform: translateX(24px);
    }

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }

      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .login-card {
      animation: fadeIn 0.5s ease-out;
    }

    .password-toggle-btn {
      position: absolute;
      left: 12px;
      top: 50%;
      transform: translateY(-50%);
      background: none;
      border: none;
      color: var(--text-secondary);
      cursor: pointer;
      padding: 4px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: var(--transition);
    }

    .password-toggle-btn:hover {
      color: var(--primary-accent);
    }

    .password-input-padded {
      padding-left: 45px !important;
    }
  </style>
</head>

<body>

  <main>

    <div class="theme-switch-wrapper">
      <span class="theme-label" id="theme-status">الوضع الفاتح</span>
      <label class="theme-switch" for="checkbox">
        <input type="checkbox" id="checkbox" />
        <div class="slider round"></div>
        <span class="sr-only">تبديل الوضع الليلي</span>
      </label>
    </div>

    <section class="login-card" aria-labelledby="login-heading">

      <div class="brand-header">
        <div class="logo-placeholder" aria-hidden="true">😊</div>

        <h1 id="login-heading" class="main-heading">تسجيل الدخول</h1>
        <p class="sub-heading">مرحباً بك في لوحة قيادة مدرسة SESB</p>
      </div>

      <form action="{{ route('dashboard.login') }}" method="POST">
        @csrf

        @if ($errors->any())
          <div
            style="background-color: #FEE2E2; color: #DC2626; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #FECACA; text-align: right;">
            <ul style="list-style: none; margin: 0; padding: 0;">
              @foreach ($errors->all() as $error)
                <li>⚠️ {{ $error }}</li>
              @endforeach
            </ul>
          </div>
        @endif

        <div class="form-group">
          <label for="username" class="form-label">اسم المستخدم أو البريد الإلكتروني</label>
          <div class="input-wrapper">
            <input type="text" id="username" name="username" class="form-input" placeholder="ادخل البريد الإلكتروني"
              required value="{{ old('username') }}">
          </div>
        </div>

        <div class="form-group">
          <label for="password" class="form-label">كلمة المرور</label>
          <div class="input-wrapper">
            <input type="password" id="password" name="password" class="form-input password-input-padded"
              placeholder="ادخل كلمة المرور" required>

            <button type="button" id="togglePasswordBtn" class="password-toggle-btn" aria-label="إظهار كلمة المرور">
              <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24"
                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                <circle cx="12" cy="12" r="3"></circle>
              </svg>
              <svg id="eyeSlashIcon" style="display: none;" xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                stroke-linejoin="round">
                <path
                  d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24">
                </path>
                <line x1="1" y1="1" x2="23" y2="23"></line>
              </svg>
            </button>
          </div>
        </div>

        <button type="submit" class="submit-btn">تسجيل الدخول</button>
      </form>
    </section>
  </main>

  <script>
    const toggleSwitch = document.querySelector('.theme-switch input[type="checkbox"]');
    const themeStatus = document.getElementById('theme-status');
    const currentTheme = localStorage.getItem('theme');

    if (currentTheme) {
      document.documentElement.classList.add(currentTheme);

      if (currentTheme === 'dark-mode') {
        toggleSwitch.checked = true;
        themeStatus.textContent = "الوضع الداكن";
      }
    }

    function switchTheme(e) {
      if (e.target.checked) {
        document.documentElement.classList.add('dark-mode');
        localStorage.setItem('theme', 'dark-mode');
        themeStatus.textContent = "الوضع الداكن";
      } else {
        document.documentElement.classList.remove('dark-mode');
        localStorage.setItem('theme', 'light-mode');
        themeStatus.textContent = "الوضع الفاتح";
      }
    }

    toggleSwitch.addEventListener('change', switchTheme, false);

    const togglePasswordBtn = document.getElementById('togglePasswordBtn');
    const passwordInput = document.getElementById('password');
    const eyeIcon = document.getElementById('eyeIcon');
    const eyeSlashIcon = document.getElementById('eyeSlashIcon');

    togglePasswordBtn.addEventListener('click', function () {
      const isPassword = passwordInput.getAttribute('type') === 'password';

      passwordInput.setAttribute('type', isPassword ? 'text' : 'password');

      if (isPassword) {
        eyeIcon.style.display = 'none';
        eyeSlashIcon.style.display = 'block';
      } else {
        eyeIcon.style.display = 'block';
        eyeSlashIcon.style.display = 'none';
      }
    });
  </script>
</body>

</html>