<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>تسجيل الدخول الآمن</title>
  <link href="https://fonts.googleapis.com/css2?family=Amiri:wght@400;700&display=swap" rel="stylesheet">

  <style>
    :root {
      --primary-color: #D3FF54;
      --bg-dark: #0f172a;
      --text-light: #ffffff;
    }

    body {
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
      background-color: var(--bg-dark);
      font-family: 'Amiri', serif;
      color: var(--text-light);
      text-align: center;
    }

    .content-header {
      width: 85%;
      margin-bottom: 30px;
    }

    h1 {
      font-size: 32px;
      margin-bottom: 10px;
      font-weight: 400;
    }

    p {
      font-size: 32px;
      line-height: 1.6;
      color: #cbd5e1;
      margin-bottom: 0;
    }

    .huge-submit-btn {
      width: 90%;
      height: 250px;
      background-color: var(--primary-color);
      color: #000F24;
      border: none;
      border-radius: 24px;
      font-size: 32px;
      font-weight: bold;
      cursor: pointer;
      box-shadow: 0 15px 30px rgba(79, 70, 229, 0.4);
      transition: transform 0.2s;
      -webkit-tap-highlight-color: transparent;
    }

    .huge-submit-btn:active {
      transform: scale(0.95);
      background-color: #4338ca;
    }

    #status-announcer {
      margin-top: 20px;
      font-size: 32px;
      color: #64748b;
    }

    .loader {
      width: 20px;
      height: 20px;
      border: 3px solid rgba(255, 255, 255, 0.2);
      border-top-color: white;
      border-radius: 50%;
      display: inline-block;
      animation: spin 1s linear infinite;
      margin-right: 8px;
      vertical-align: middle;
    }

    @keyframes spin {
      to {
        transform: rotate(360deg);
      }
    }

    .huge-submit-btn {
      width: 350px;
      height: 100px;
      background-color: var(--primary-color);
      color: #000F24;
      border: none;
      border-radius: 15px;

      font-family: 'Amiri', serif;
      font-size: 40px;
      font-weight: 400;
      letter-spacing: 1px;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);

      cursor: pointer;
      box-shadow: 0 15px 30px #8BA82A;
      transition: all 0.2s;
      -webkit-tap-highlight-color: transparent;
    }
  </style>
</head>

<body>

  <header class="content-header">
    <h1 aria-label="ترحيب">أهلاً بك، {{ $student->fullname }}</h1>
    <p>سيتم فتح التطبيق وتسجيل دخولك تلقائياً الآن.<br> يمكنك الضغط على الزر أدناه للبدء فوراً.</p>
  </header>

  <form id="loginForm" action="{{ $postUrl }}" method="POST" style="width: 100%;">
    @csrf
    <button type="submit" class="huge-submit-btn" autofocus>
      فتح التطبيق والدخول
    </button>
  </form>

  <div id="status-announcer" aria-live="assertive">
    <div class="loader"></div>
    جاري التحويل تلقائياً...
  </div>

  <script>
    window.onload = function () {
      setTimeout(function () {
        document.getElementById('status-announcer').innerText = "يتم الآن فتح التطبيق...";
        document.getElementById('loginForm').submit();
      }, 3000);
    };
  </script>

</body>

</html>