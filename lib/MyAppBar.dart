import 'package:flutter/material.dart';
class MyAppBar extends StatelessWidget{
  const MyAppBar({super.key}); // constructor trùng với class
  // ctrl +  space : ra được override
  @override
  Widget build(BuildContext context) {
    // trả về scaffold - widget cung cấp bố cục material design cơ bản
    // màn hình
    return Scaffold(
      // tiêu đề của ứng dụng
      appBar: AppBar(
        // tiêu đề
        title: Text("app của tôi"),
        //màu nền
        backgroundColor: Colors.blue,
        // do nặng/ độ bóng appbar
        elevation: 4,
        actions: [
          IconButton(onPressed: (){print("b2");},
              icon: Icon(Icons.search)),
          IconButton(onPressed: (){print("b3");},
              icon: Icon(Icons.abc)),
          IconButton(onPressed: (){print("b4");},
              icon: Icon(Icons.more_vert))
        ],

      ),

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
