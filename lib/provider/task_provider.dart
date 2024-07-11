import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';
import 'package:todo/service/taskservice.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final TaskService _taskService = TaskService();

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks(int userId) async {
    try {
      _tasks = await _taskService.getTasks(userId);
      notifyListeners();
    } catch (e) {
      print('Erreur de récupération des tâches : $e');
    }
  }

  Future<void> addTask(int userId, String title, String description) async {
    try {
      Task newTask = await _taskService.addTask(userId, title, description);
      _tasks.insert(0, newTask); // Add new task at the top
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'ajout de la tâche : $e');
    }
  }

  Future<void> updateTask(int taskId, String title, String description) async {
    try {
      await _taskService.updateTask(taskId, title, description);
      int index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index].title = title;
        _tasks[index].description = description;
        notifyListeners();
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la tâche : $e');
    }
  }

  Future<void> toggleComplete(int taskId, bool completed) async {
    try {
      await _taskService.toggleComplete(taskId, completed);
      int index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index].completed = completed;
        notifyListeners();
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la tâche : $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la suppression de la tâche : $e');
    }
  }
}
