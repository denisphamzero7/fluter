import 'package:app_02/App.dart';
import 'package:app_02/App/AppNew.dart';
import 'package:app_02/App/ListViewPage.dart';
import 'package:app_02/App/MainShell.dart';
import 'package:app_02/App/PostDetailScreen.dart';
import 'package:app_02/App/camera/camera_scan_screen.dart';
import 'package:app_02/App/company/screens/company_list_screen.dart';
import 'package:app_02/App/create_feedback_screen.dart';
import 'package:app_02/App/auth/screens/login.dart';
import 'package:app_02/App/auth/screens/register.dart';
import 'package:app_02/Form/PostFormScreen.dart';
import 'package:app_02/MyAppBar.dart';
import 'package:app_02/MyButton.dart';
import 'package:app_02/MyColumnAndRow.dart';
import 'package:app_02/MyContainer.dart';
import 'package:app_02/MyText.dart';
import 'package:app_02/MyTextField.dart';
import 'package:app_02/Mybutton2.dart';

import 'package:flutter/material.dart';
import '../MyScaffold.dart';
import 'auth/screens/auth_check_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthCheckScreen(),
      routes: {
        '/detail': (context) => const PostDetailScreen(),
        '/form': (context) => const PostFormScreen(),
        '/create-feedback': (context) => const AddFeedbackScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/company': (context) => const CompanyListScreen(),
        '/scanner_cccd': (context) => const CameraScanScreen(),
        // '/scanner_cccd': (context) => const CameraScanScreen(),


      },
    );
  }
}

