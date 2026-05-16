// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_services.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _WebServices implements WebServices {
  _WebServices(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'http://10.0.2.2:8000/api/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<TeacherModel> registerTeacher({
    required String phone,
    required String fullName,
    required String password,
    required String passwordConfirmation,
    required String subjects,
    required String level,
    required String fcmToken,
    required MultipartFile cvFile,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('phone', phone));
    _data.fields.add(MapEntry('full_name', fullName));
    _data.fields.add(MapEntry('password', password));
    _data.fields.add(MapEntry('password_confirmation', passwordConfirmation));
    _data.fields.add(MapEntry('subjects', subjects));
    _data.fields.add(MapEntry('level', level));
    _data.fields.add(MapEntry('fcm_token', fcmToken));
    _data.files.add(MapEntry('cv', cvFile));
    final _options = _setStreamType<TeacherModel>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'teacher/register',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TeacherModel _value;
    try {
      _value = TeacherModel.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
