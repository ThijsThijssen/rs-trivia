import 'package:json_annotation/json_annotation.dart';

part 'trivia_question.g.dart';

@JsonSerializable(explicitToJson: true)
class TriviaQuestion {
  TriviaQuestion(this.tier, this.question, this.correctAnswer, this.answers);

  String tier;
  String question;
  String correctAnswer;
  List<String> answers;

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) =>
      _$TriviaQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$TriviaQuestionToJson(this);
}
