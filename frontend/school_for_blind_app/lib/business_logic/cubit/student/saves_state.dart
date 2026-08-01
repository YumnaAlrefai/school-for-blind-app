import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

part 'saves_state.freezed.dart';

@freezed
class SavesState with _$SavesState {
  const factory SavesState.initial() = _Initial;
  const factory SavesState.loading() = _Loading;
  const factory SavesState.success(int id, String type, bool isSaved) =
      _Success;
  const factory SavesState.failure(NetworkExceptions networkExceptions) =
      _Failure;
}
