import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_bloc/screens/tabs_screen.dart';

import '../screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                        .signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim())
                        .then((userCredential) {
                          // Navigate to home screen or another screen after successful login
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login successful"), backgroundColor: Colors.green));
                          Navigator.of(context).pushReplacementNamed(TabsScreen.id);
                        })
                        .catchError((error) {
                          // Handle login error
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Colors.red));
                        });
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.id);
                },
                child: const Text('Don\'t have an Account?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ForgotPasswordScreen.id);
                },
                child: const Text('Forget Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
