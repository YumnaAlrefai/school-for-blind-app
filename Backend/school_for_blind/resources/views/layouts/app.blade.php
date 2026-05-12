<!DOCTYPE html>
<html lang="ar" dir="ltr">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>لوحة تحكم المدرسة</title>

  <link href="{{ asset('vendor/fontawesome-free/css/all.min.css') }}" rel="stylesheet" type="text/css">

  <link href="{{ asset('css/sb-admin-2.min.css') }}" rel="stylesheet">

  <link href="{{ asset('css/custom.css') }}" rel="stylesheet">
  
  <style>
    body {
      font-family: 'Arabic Typesetting', serif;
      font-size: 26px;
    }

    .bg-custom-dark {
      background-color: #000F24 !important;
    }

    .text-custom-accent {
      color: #D3FF54 !important;
    }
  </style>
</head>

<body id="page-top">

  <div id="wrapper">

    @include('layouts.sidebar')

    <div id="content-wrapper" class="d-flex flex-column">

      <div id="content">

        @include('layouts.header')

        <div class="container-fluid">
          @yield('content')
        </div>

      </div>
      @include('layouts.footer')

    </div>
  </div>
  <script src="{{ asset('vendor/jquery/jquery.min.js') }}"></script>
  <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
  <script src="{{ asset('vendor/jquery-easing/jquery.easing.min.js') }}"></script>
  <script src="{{ asset('js/sb-admin-2.min.js') }}"></script>

</body>

</html>