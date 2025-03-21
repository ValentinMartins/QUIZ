import 'question.dart';

class Quiz {
  List<Question> questions = [
    Question(
      id: 1,
      text: "Quelle est la capitale de la France ?",
      options: [
        Answer(id: 1, text: "Berlin"),
        Answer(id: 2, text: "Madrid"),
        Answer(id: 3, text: "Paris"),
        Answer(id: 4, text: "Rome"),
      ],
      correctIndex: 2,
    ),
    Question(
      id: 2,
      text: "Quel est le langage utilisé pour Flutter ?",
      options: [
        Answer(id: 1, text: "Java"),
        Answer(id: 2, text: "Dart"),
        Answer(id: 3, text: "Kotlin"),
        Answer(id: 4, text: "Swift"),
      ],
      correctIndex: 1,
    ),
  ];
}
