// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
// import 'package:school_for_blind_app/data/models/question_model.dart';
// import 'package:school_for_blind_app/data/repository/student_repo.dart';

// class QuestionsCubit extends Cubit<ResultState<dynamic>> {
//   final StudentRepo studentRepo;

//   List<QuestionModel> _questions = [];

//   QuestionsCubit(this.studentRepo) : super(const ResultState.idle());
//   void loadMockQuestions() {
//     final mockList = [
//       QuestionModel(
//         number: 4,
//         text: "قانون الهوية هو من قوانين الفكر",
//         points: 3,
//         type: QuizQuestionType.trueOrfalse,
//       ),
//       QuestionModel(
//         number: 5,
//         text: "ماهي قوانين الفكر؟",
//         points: 7,
//         type: QuizQuestionType.essay,
//       ),
//       QuestionModel(
//         number: 6,
//         text: "من مؤسس علم المنطق الصوري؟",
//         points: 5,
//         type: QuizQuestionType.multipleChoice,
//         options: ["أرسطو", "أفلاطون", "سقراط", "ديكارت"],
//       ),
//     ];
//     emit(ResultState.success(questions: mockList, userAnswers: {}));
//   }

//   void selectAnswer(int questionNumber, String answer) {
//     final updatedAnswers = Map<int, String>.from(state.userAnswers);
//     updatedAnswers[questionNumber] = answer;
//     emit(QuizState(questions: state.questions, userAnswers: updatedAnswers));
//   }
// }

//   // void emitGetAllLessons({
//   //   String currency = 'usd',
//   //   int perPage = 10,
//   //   int page = 1,
//   //   bool sparkline = true,
//   //   String priceChangePercentage = '24h',
//   // }) async {
//   //   emit(const LessonState.loading());
//   //   final data = await LessonRepo.getAllLessons(
//   //     currency,
//   //     perPage,
//   //     page,
//   //     sparkline,
//   //     priceChangePercentage,
//   //   );

//   //   data.when(
//   //     success: (List<Lesson> allLessons) {
//   //       _allLessonsOriginal = allLessons;
//   //       emit(LessonState.success(allLessons));
//   //     },
//   //     failure: (networkException) => emit(LessonState.failure(networkException)),
//   //   );
//   // }



