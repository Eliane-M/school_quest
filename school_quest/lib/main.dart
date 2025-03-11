import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'welcome_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'email_verification_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Quest',
      theme: ThemeData(
        fontFamily: 'Outfit',
        primaryColor: const Color(0xFF9D4EDD),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/emailverification': (context) => const EmailVerificationScreen(),
      },
    );
  }
}
