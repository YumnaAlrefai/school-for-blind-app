// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PastExamsResponse _$PastExamsResponseFromJson(Map<String, dynamic> json) =>
    PastExamsResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => PastExam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PastExamsResponseToJson(PastExamsResponse instance) =>
    <String, dynamic>{'status': instance.status, 'data': instance.data};

PastExam _$PastExamFromJson(Map<String, dynamic> json) => PastExam(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  year: json['year'] as String,
  session: json['session'] as String,
  isSaved: json['is_favorited'] as bool,
);

Map<String, dynamic> _$PastExamToJson(PastExam instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'year': instance.year,
  'session': instance.session,
  'is_favorited': instance.isSaved,
};
