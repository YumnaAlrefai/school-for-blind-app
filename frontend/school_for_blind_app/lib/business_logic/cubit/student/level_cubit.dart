import 'package:flutter_bloc/flutter_bloc.dart';

enum StudentLevel { none, ninth, twelfth }

class LevelCubit extends Cubit<StudentLevel> {
  LevelCubit() : super(StudentLevel.none);

  void selectLevel(StudentLevel level) => emit(level);

  void resetLevel() => emit(StudentLevel.none);
}
