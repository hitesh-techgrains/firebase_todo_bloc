import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_bloc/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:techgrains/com/techgrains/common/tg_log.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Insert email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Insert password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password should be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  _auth
                      .createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim())
                      .then((userCredential) {
                        // User registration successful
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Registration successful'), backgroundColor: Colors.green));
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      })
                      .catchError((error) {
                        // Handle registration error
                        TGLog.d('Registration error: ${error.toString()}');
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Registration failed: ${error.message}'), backgroundColor: Colors.red));
                      });
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
