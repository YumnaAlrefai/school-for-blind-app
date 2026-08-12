import 'package:parent_project/features/auth/data/models/logout_response_model.dart';

import '../datasource/auth_remote_datasource.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';


class AuthRepository {


  final AuthRemoteDataSource remoteDataSource;


  AuthRepository(
    this.remoteDataSource,
  );


  Future<LoginResponseModel> login(
      LoginRequestModel request
  ) async {

    return await remoteDataSource.login(request);

  }
Future<LogoutResponseModel> logout() async {
  return await remoteDataSource.logout();
}

}