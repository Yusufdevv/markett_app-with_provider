import 'package:flutter/material.dart';
import 'package:markett_app/providers/auth.dart';
import 'package:markett_app/services/http_exception.dart';
import 'package:provider/provider.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Xatolik!"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("OKEY"))
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authMode == AuthMode.Login) {
          // login user
        await  Provider.of<Auth>(context, listen: false)
              .login(_authData['email']!, _authData['password']!);
        } else {
          // register user
          await Provider.of<Auth>(context, listen: false).signup(
            _authData['email']!,
            _authData['password']!,
          );
        }
      } on HttpException catch (error) {
        var errorMessage = "Xatolik sodir bo'ldi!";
        if (error.message.contains('EMAIL_EXISTS')) {
          errorMessage = "BU email band.";
        } else if (error.message.contains('INVALID_EMAIL')) {
          errorMessage = "Noto'g'ri email kiritdingiz";
        } else if (error.message.contains('WEAK_PASSWORD')) {
          errorMessage = "Juda oson parol";
        } else if (error.message.contains('EMAIL_NOT_FOUND')) {
          errorMessage = "BU email bilan foydalanuvchi topilmadi.";
        } else if (error.message.contains('INVALID_PASSWORD')) {
          errorMessage = "Parol noto'g'ri.";
        }
        _showErrorDialog(errorMessage);
      } catch (error) {
        var errorMessage = "Kechirasiz, xatolik sodir bo'ldi!";
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  // fit: BoxFit.cover,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email manzil"),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return "Iltimos, Email manzilini kiriting!";
                    } else if (!email.contains("@")) {
                      return "Iltimos, to'g'ri email kiriting!";
                    }
                    return null;
                  },
                  onSaved: (email) {
                    _authData['email'] = email!;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Parol"),
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return "Iltimos, parolni kiriting!";
                    } else if (password.length < 6) {
                      return "Parol oson";
                    }
                    return null;
                  },
                  onSaved: (password) {
                    _authData['password'] = password!;
                  },
                ),
                if (_authMode == AuthMode.Register)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Parolni tasdiqlang"),
                        validator: (currentPassword) {
                          if (_passwordController.text != currentPassword) {
                            return "Parollar bir biriga mos kelmadi!";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 50),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                        onPressed: _submit,
                        child: Text(_authMode == AuthMode.Login
                            ? "KIRISH"
                            : "RO'YXATDAN O'TISH"),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login
                        ? "Ro'yxatdan o'tish"
                        : "Kirish",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
