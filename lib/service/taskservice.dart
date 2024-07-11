import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo/model/task.dart';

class TaskService {
  static const String baseUrl = 'http://localhost/todo'; // Remplacez par l'URL de votre API

  Future<List<Task>> getTasks(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks.php?userId=$userId'));

      if (response.statusCode == 200) {
        final tasks = jsonDecode(response.body) as List<dynamic>;
        return tasks.map((task) => Task.fromMap(task as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des tâches');
      }
    } catch (e) {
      throw Exception('Erreur de récupération des tâches : $e');
    }
  }

  Future<Task> addTask(int userId, String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks.php'),
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'description': description,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final taskData = jsonDecode(response.body) as Map<String, dynamic>;
        return Task.fromMap({
          'id': taskData['taskId'],
          'userId': userId,
          'title': title,
          'description': description,
          'completed': false,
        });
      } else {
        throw Exception('Erreur lors de l\'ajout de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de la tâche : $e');
    }
  }

  Future<void> updateTask(int taskId, String title, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks.php'),
        body: jsonEncode({
          'taskId': taskId,
          'title': title,
          'description': description,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la tâche : $e');
    }
  }

  Future<void> toggleComplete(int taskId, bool completed) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks.php'),
        body: jsonEncode({
          'taskId': taskId,
          'completed': completed ? 1 : 0,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la tâche : $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks.php?taskId=$taskId'));

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression de la tâche');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la tâche : $e');
    }
  }
}
