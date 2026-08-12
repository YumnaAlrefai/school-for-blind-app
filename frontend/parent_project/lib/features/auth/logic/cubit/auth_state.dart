import 'package:equatable/equatable.dart';

import '../../data/models/login_response_model.dart';


abstract class AuthState extends Equatable {
const AuthState();

  @override
  List<Object?> get props => [];

}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {

  final LoginResponseModel response;

  AuthSuccess(this.response);

}

class AuthFailure extends AuthState {

  final String message;

  AuthFailure(this.message);

}
class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {
  final String message;

  LogoutSuccess(this.message);
}

class LogoutFailure extends AuthState {
  final String message;

  LogoutFailure(this.message);
}