


import 'package:app_02/App/MainShell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class AuthCheckScreen extends StatefulWidget{

  const AuthCheckScreen({Key? key}) : super(key: key);
  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();

}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthStatus();
  }
  Future<void> _checkAuthStatus() async {

    // lấy instance của SharedPreferences
    final  prefs = await SharedPreferences.getInstance();
    // Đọc token từ SharedPreferences
    final String? token = prefs.getString('token');

    // Kiểm tra trạng thái đăng nhập
    if(!mounted) return;

    // Điều hướng dựa trên kết quả
    if(token != null && token.isNotEmpty){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=> const MainShell()),);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context)=> const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),);
  }


}
