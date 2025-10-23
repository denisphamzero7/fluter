import 'package:flutter/material.dart';
class MyButton extends StatelessWidget{
  const MyButton({super.key}); // constructor trùng với class
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


      body:  Center(child: Column(
        children: [
          SizedBox(height: 20,),
          //elevatedbuton  là 1 button nổi với hiệu ứng đổ bóng
          ElevatedButton(onPressed:(){print("elevatedbutton");} , child: Text("Elevated button"),style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            // màu chữ
            foregroundColor: Colors.white,
            // dạng hình nút nhấn
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            padding: EdgeInsets.symmetric(

              horizontal: 20,// ngang
              vertical: 15,// dọc
            ),
            //đổ bóng
            elevation: 10
          ),),
          SizedBox(height: 20,),
          // nút không có viền
          TextButton(onPressed: (){print("Nút button phẳng");}, child: Text("Text button")),
          // nút có viềng
          OutlinedButton(onPressed: (){print("Nút có viềng");}, child: Text("Nút có viềng"),),
          // Nút nhaấn có dạng icon
          IconButton(onPressed: (){print("Nút icon");}, icon: Icon( Icons.abc_rounded,)
            ,style: IconButton.styleFrom(
            backgroundColor: Colors.blue, // 👈 Màu nền
            foregroundColor: Colors.white, // 👈 Màu của icon (để nổi bật)
          ),)

        ],
      ),),
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
