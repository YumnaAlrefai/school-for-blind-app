import 'dart:io';

import 'package:dio/dio.dart';
import 'package:school_for_blind_app/data/web_services/auth_web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class AuthRepo {
  final WebServices webServices;

  AuthRepo(this.webServices);

  Future<ApiResult<dynamic>> sendOTP(String phone) async {
    try {
      var response = await webServices.sendOTP(phone);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> verifyOTP(String phone, String otp) async {
    try {
      var response = await webServices.verifyOTP(phone, otp);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> register(
    String fullName,
    String fatherName,
    String phone,
    String parentPhone,
    String level,
    File documentaryEvidence,
  ) async {
    try {
      var response = await webServices.register(
        fullName,
        fatherName,
        phone,
        parentPhone,
        level,
        await MultipartFile.fromFile(
          documentaryEvidence.path,
          filename: documentaryEvidence.path.split('/').last,
        ),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> login(String phone) async {
    try {
      var response = await webServices.login(phone);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> magicLogin(String token) async {
    try {
      var response = await webServices.magicLogin(token);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}
