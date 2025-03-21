import 'package:flutter/material.dart';
import 'package:school_quest/admin_dashboard/add_user_page.dart';
import 'package:school_quest/admin_dashboard/edit_profile_page.dart';
import 'package:school_quest/admin_dashboard/school_list_page.dart';
import 'package:school_quest/admin_dashboard/welcome_page.dart';
import 'package:school_quest/user_dashboard/search_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_quest/user_dashboard/user_profile_edit.dart';
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
import 'admin_dashboard/analytics_page.dart';
import 'admin_dashboard/schools_page.dart';
import 'admin_dashboard/admin_profile_page.dart';
import 'firebase_options.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
  }

  Future<void> _initDynamicLinks() async {
    // Handle link when app is opened from terminated state
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _handleDynamicLink(initialLink);
    }

    // Handle links when app is in background/foreground
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  void _handleDynamicLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;
    if (deepLink.queryParameters.containsKey('oobCode')) {
      // Use Navigator.of(context) with root navigator to ensure navigation works
      Navigator.of(context, rootNavigator: true).pushNamed(
        '/newpassword',
        arguments: {'oobCode': deepLink.queryParameters['oobCode']},
      );
    }
  }
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
        '/usereditprofile': (context) => UserEditProfilePage(),
        '/admindashboard': (context) => AdminHomePage(),
        '/analytics': (context) => OverviewScreen(),
        '/schools': (context) => SchoolsDashboard(),
        '/schoollist': (context) => SchoolListScreen(),
        '/usermanagement': (context) => UserManagementScreen(),
        '/editprofile': (context) => EditProfilePage(),
        '/adminprofile': (context) => AdminProfilePage(),
      },
    );
  }
}
