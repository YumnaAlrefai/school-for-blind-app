import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/channel_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class ChannelsCubit extends Cubit<ResultState<ChannelsResponse>> {
  final StudentRepo studentRepo;

  ChannelsCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> getAllChannels() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getAllChannels();

    response.when(
      success: (data) => emit(ResultState.success(data)),
      failure: (e) => emit(ResultState.failure(e)),
    );
  }
}
