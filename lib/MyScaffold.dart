import 'package:flutter/material.dart';
class MyScaffold extends StatelessWidget{
    const MyScaffold({super.key}); // constructor trùng với class
    // ctrl +  space : ra được override
@override
  Widget build(BuildContext context) {
   // trả về scaffold - widget cung cấp bố cục material design cơ bản
  // màn hình
  return Scaffold(
    // tiêu đề của ứng dụng
   appBar: AppBar(
     title: Text("app của tôi"),
   ),
    backgroundColor: Colors.amberAccent,
    body: Center(child:  Text("Nội dung của tôi"),),
    floatingActionButton: FloatingActionButton(onPressed: (){},
      child: const Icon(Icons.add_ic_call),),
    // thanh điều hướng ở dưới
    bottomNavigationBar:BottomNavigationBar (items:[
      BottomNavigationBarItem(icon: Icon(Icons.home),label:"trang chủ"),
      BottomNavigationBarItem(icon: Icon(Icons.search),label:"Tìm kiếm"),
      BottomNavigationBarItem(icon: Icon(Icons.person),label:"Cá nhân"),
    ]),
  );
  }
}
