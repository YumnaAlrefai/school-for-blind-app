<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login to App</title>
</head>

<body
  style="display: flex; justify-content: center; align-items: center; height: 100vh; background: #f3f4f6; font-family: sans-serif;">

  <div
    style="text-align: center; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
    <h2>أهلاً بك مجدداً، {{ $student->fullname }}!</h2>
    <p>اضغط على الزر أدناه لفتح التطبيق وتسجيل الدخول بأمان.</p>

    <form action="{{ $postUrl }}" method="POST">
      @csrf
      <button type="submit"
        style="padding: 12px 24px; background: #4F46E5; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer;">
        فتح التطبيق وتسجيل الدخول </button>
    </form>
  </div>

</body>

</html>

{{--
<a href="schoolblind://magic-login?id=5&signature=xyz&expires=123"
  style="padding: 10px 20px; background: blue; color: white; text-decoration: none; border-radius: 5px;">
  العودة للتطبيق لتسجيل الدخول
</a>

<script>
  window.onload = function () {
    // بعد ثانيتين من فتح الصفحة، الموبايل لحاله رح يحاول يفتح التطبيق
    setTimeout(function () {
      window.location.href = "schoolblind://magic-login?id=5&signature=xyz&expires=123";
    }, 2000);
  };
</script>
--}}