import 'package:flutter_bloc/flutter_bloc.dart';

enum UserRole { none, student, teacher }

class RoleCubit extends Cubit<UserRole> {
  RoleCubit() : super(UserRole.none);

  void selectRole(UserRole role) => emit(role);
}
