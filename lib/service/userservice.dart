import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo/model/user.dart';

class UserService {
  static const String baseUrl = 'http://localhost/todo'; // Remplacez par l'URL de votre API

  Future<User?> registerUser(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {'email': email, 'password': password},
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData.containsKey('message') && responseData['message'] == 'Inscription réussie') {
        // L'inscription a réussi, vous pouvez créer un objet User avec les données appropriées
        return User(id: 0, email: email, password: password, createdAt: DateTime.now());
      } else {
        throw Exception('Erreur d\'inscription');
      }
    } else {
      throw Exception('Erreur d\'inscription. Code de statut : ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erreur d\'inscription : $e');
  }
}
  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        body: {'email': email, 'password': password},
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>;
        if (userData.containsKey('user')) {
          return User.fromMap(userData['user']);
        } else {
          throw Exception('Utilisateur non trouvé dans la réponse');
        }
      } else {
        throw Exception('Identifiants invalides');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}
