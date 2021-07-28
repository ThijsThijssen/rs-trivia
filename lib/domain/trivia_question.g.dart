// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trivia_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TriviaQuestion _$TriviaQuestionFromJson(Map<String, dynamic> json) {
  return TriviaQuestion(
    json['tier'] as String,
    json['question'] as String,
    json['correctAnswer'] as String,
    (json['answers'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$TriviaQuestionToJson(TriviaQuestion instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'question': instance.question,
      'correctAnswer': instance.correctAnswer,
      'answers': instance.answers,
    };
