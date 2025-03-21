import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  static const String apiUrl = "https://run.mocky.io/v3/ec8eb9bb-db33-485b-982b-5e4af5f81f78";

  static Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['questions'] as List).map((json) => Question.fromJson(json)).toList();
      } else {
        throw Exception("Erreur de chargement : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Impossible de charger les questions : $e");
    }
  }
}
