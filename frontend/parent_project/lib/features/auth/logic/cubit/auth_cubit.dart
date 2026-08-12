import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login_request_model.dart';
import '../../data/repositories/auth_repository.dart';

import 'auth_state.dart';
import 'package:parent_project/core/utils/token_storage.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository repository;


  AuthCubit(
    this.repository,
  ) : super(AuthInitial());



  Future<void> login({
    required String phone,
    required String password,
  }) async {

    emit(AuthLoading());


    try {

      final result = await repository.login(

        LoginRequestModel(
          phone: phone,
          password: password,
        ),

      );
      await TokenStorage.saveToken(result.token);


      emit(
        AuthSuccess(result),
        
      );


    } catch(e) {
print("LOGIN ERROR =================");
   print(e);
      emit(
        AuthFailure(
          e.toString(),
        ),
      );


    }

  }
  Future<void> logout() async {
  emit(LogoutLoading());

  try {
    final result = await repository.logout();

    await TokenStorage.clearToken();

    emit(LogoutSuccess(result.message));
  } catch (e) {
    print("LOGOUT ERROR =================");
    print(e);
    emit(LogoutFailure(e.toString()));
  }
}

}