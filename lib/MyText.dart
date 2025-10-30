import 'package:flutter/material.dart';

// SỬA TÊN CLASS TẠI ĐÂY
class MyTextField extends StatelessWidget{
  const MyTextField({super.key}); // SỬA CẢ TÊN HÀM CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    // tr
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

      body: Center(child: Column(
        // text cơ bản
        children: [
          const SizedBox(height: 50,),
          const Text("Phạm nhật vượng"),
          const SizedBox(height: 50,),
          const Text(
            " xin chào các bạn",
            maxLines: 3,// quy định so dòng
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 5,

            ),
          ),
          const SizedBox(height: 21,),
          const Text(
            " Viết chatbot dùng để tra cứu thông tin Setup trợ lí ảo: docker, enything llm, ollama. Học phần cứng PC. Đăng bài viết website về  cyberpanel Học sử dụng usb boot Học cài đặt máy in trên máy tính và chia sẻ kết nối máy in qua mạng Đăng bài viết trên website Cập nhập Vuejs Tutorial cho website Ôn tập python và nestj",
            maxLines: 5,// quy định so dòng
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,

              letterSpacing: 2,

            ),
          )
        ],
      )),
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
