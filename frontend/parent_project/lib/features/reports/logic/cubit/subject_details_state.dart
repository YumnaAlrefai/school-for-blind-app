import '../../data/models/subject_details_response_model.dart';

abstract class SubjectDetailsState {}

class SubjectDetailsInitial extends SubjectDetailsState {}

class SubjectDetailsLoading extends SubjectDetailsState {}

class SubjectDetailsSuccess extends SubjectDetailsState {
  final SubjectDetailsResponseModel response;
  SubjectDetailsSuccess(this.response);
}

class SubjectDetailsFailure extends SubjectDetailsState {
  final String message;
  SubjectDetailsFailure(this.message);
}