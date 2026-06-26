import 'dart:io';

import 'package:dio/dio.dart';
import 'package:school_for_blind_app/data/models/announcement.dart';
import 'package:school_for_blind_app/data/models/call.dart';
import 'package:school_for_blind_app/data/models/join_call_response.dart';
import 'package:school_for_blind_app/data/web_services/student_web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class StudentRepo {
  final StudentWebServices webServices;

  StudentRepo(this.webServices);

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

  Future<ApiResult<dynamic>> exchangeToken(String oldToken) async {
    try {
      var response = await webServices.exchangeToken(oldToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> logout() async {
    try {
      var response = await webServices.logout();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Call>>> getCalls() async {
    try {
      final Map<String, dynamic> response = await webServices.getCalls();
      final List<dynamic> rawList = response['data'];
      List<Call> calls = rawList.map((json) => Call.fromJson(json)).toList();

      return ApiResult.success(calls);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<JoinCallResponse>> joinCall(String roomName) async {
    try {
      var response = await webServices.joinCall(roomName);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> donate(Map<String, dynamic> donation) async {
    try {
      var response = await webServices.donate(donation);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      var response = await webServices.confirmPayment({
        "payment_intent_id": paymentIntentId,
      });
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<Announcement>>> getAnnouncements() async {
    try {
      final List<Announcement> response = await webServices.getAnnouncements();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}
