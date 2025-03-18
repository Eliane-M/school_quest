import 'package:flutter/material.dart';
import 'package:school_quest/user_dashboard/search_page.dart';
import 'signin_page.dart';
import 'welcome_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'email_verification_page.dart';
import 'new_password_page.dart';
import 'successful_set_page.dart';
import 'user_dashboard/welcome_page.dart';
import 'user_dashboard/overview_page.dart';
import 'user_dashboard/help_center_page.dart';
import 'user_dashboard/profile_page.dart';

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
        fontFamily: 'Poppins',
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
        '/newpassword': (context) => SetNewPasswordPage(),
        '/successfulset': (context) => const SuccessfulSetPage(),
        '/userdashboard': (context) => SchoolHomePage(),
        '/overview': (context) => SchoolListingPage(),
        '/search': (context) => SearchPage(),
        '/helpcenter': (context) => HelpCenterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
