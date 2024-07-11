import 'package:flutter/material.dart';
import 'package:todo/model/user.dart';
import 'package:todo/service/userservice.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  User? _user;

  User? get user => _user;

  Future<void> _handleError(Future<void> Function() action, String errorMessage) async {
    try {
      await action();
    } catch (e) {
      print('$errorMessage : $e');
      throw Exception(errorMessage);
    }
  }

  Future<void> registerUser(String email, String password) async {
  try {
    final newUser = await _userService.registerUser(email, password);
    if (newUser != null) {
      _user = newUser;
    } else {
      throw Exception('Erreur d\'inscription');
    }
  } catch (e) {
    print('Erreur d\'inscription : $e');
    rethrow;
  }
}

  Future<void> loginUser(String email, String password) async {
    await _handleError(() async {
      final user = await _userService.loginUser(email, password);
      if (user != null) {
        _user = user;
        notifyListeners();
      } else {
        throw Exception('Identifiants invalides');
      }
    }, 'Erreur de connexion');
  }

  void logoutUser() {
    _user = null;
    notifyListeners();
  }
}