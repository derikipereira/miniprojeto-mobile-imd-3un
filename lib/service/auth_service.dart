import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseReference _usersRef =
  FirebaseDatabase.instance.ref().child('users');

  Future<bool> register(String email, String password) async {
    try {
      final snapshot =
      await _usersRef.orderByChild('email').equalTo(email).once();

      if (snapshot.snapshot.value != null) {
        print('Usuário já existe!');
        return false;
      }

      final newUserRef = _usersRef.push();
      await newUserRef.set({
        'email': email,
        'password': password,
      });

      print('Usuário registrado com sucesso!');
      return true;
    } catch (e) {
      print('Erro durante o registro: $e');
      return false;
    }
  }
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      return true;
    }
    return false;
  }
  Future<bool> login(String email, String password) async {
    try {
      final snapshot =
      await _usersRef.orderByChild('email').equalTo(email).once();

      if (snapshot.snapshot.value != null) {
        final userMap = snapshot.snapshot.value as Map<dynamic, dynamic>;
        final user = userMap.values.first;

        if (user['password'] == password) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('password', password);

          print('Login bem-sucedido!');
          return true;
        } else {
          print('Senha incorreta!');
        }
      } else {
        print('Usuário não encontrado!');
      }

      return false;
    } catch (e) {
      print('Erro durante o login: $e');
      return false;
    }
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    print('Logout realizado com sucesso!');
  }
}
