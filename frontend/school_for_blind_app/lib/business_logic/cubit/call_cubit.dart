import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class CallCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;

  CallCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> emitJoinCall() async {
    emit(const ResultState.loading());

    final getCallsResult = await studentRepo.getCalls();

    await getCallsResult.when(
      success: (allCalls) async {
        if (allCalls.isNotEmpty) {
          final currentCall = allCalls.first;
          final roomName = currentCall.roomName;
          final startedAt = currentCall.startedAt;

          final joinResult = await studentRepo.joinCall(roomName);

          joinResult.when(
            success: (data) {
              emit(
                ResultState.success({
                  'token': data.token,
                  'room_name': roomName,
                  'started_at': startedAt,
                }),
              );
            },
            failure: (networkException) {
              emit(ResultState.failure(networkException));
            },
          );
        } else {
          emit(ResultState.success({}));
        }
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
