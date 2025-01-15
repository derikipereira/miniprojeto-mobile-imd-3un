import 'package:f09_recursos_nativos/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:f09_recursos_nativos/utils/app_routes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isUserLoggedIn();

    if (isLoggedIn) {
      final authenticated = await _authenticate();
      if (!authenticated) {
        await authService.logout();
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.PLACES_LIST);
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    final success = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.PLACES_LIST);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro de Login'),
          content: Text('Email ou senha incorretos.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<bool> _authenticate() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        _showErrorDialog('Biometria não está configurada ou suportada.');
        return false;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'Confirme sua identidade com biometria',
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return authenticated;
    } catch (e) {
      _showErrorDialog('Erro durante a autenticação: $e');
      return false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  ElevatedButton(
                    child: Text('Login'),
                    onPressed: _login,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text('Login com Biometria'),
                    onPressed: () async {
                      final authenticated = await _authenticate();
                      if (authenticated) {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutes.PLACES_LIST);
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    child: Text('Registrar-se'),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.REGISTER);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
