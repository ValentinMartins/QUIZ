import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class ApiService {
  static const String apiUrl = "https://run.mocky.io/v3/725a3a63-7ad6-4e63-9aae-63fac75aed80";

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
