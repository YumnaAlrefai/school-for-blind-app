import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
part 'result_state.freezed.dart';

@freezed
class ResultState<T> with _$ResultState<T> {
  const factory ResultState.idle() = Idle<T>;
  const factory ResultState.loading() = Loading<T>;
  const factory ResultState.success(T data) = Success<T>;
  const factory ResultState.failure(NetworkExceptions networkException) =
      Failure<T>;
}
