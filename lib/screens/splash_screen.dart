import 'dart:async';

import 'package:firebase_todo_bloc/screens/login_screen.dart';
import 'package:firebase_todo_bloc/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openNextPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void openNextPage(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      if (_getStorage.read('userId') == null || _getStorage.read('userId') == '') {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, TabsScreen.id);
      }
    });
  }
}
