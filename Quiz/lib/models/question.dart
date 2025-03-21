class Question {
  final int id;
  final String text;
  final List<Answer> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['label'],
      correctIndex: json['correct_answer_id'] - 1,
      options: (json['answers'] as List).map((answer) => Answer.fromJson(answer)).toList(),
    );
  }
}

class Answer {
  final int id;
  final String text;

  Answer({required this.id, required this.text});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(id: json['id'], text: json['label']);
  }
}
