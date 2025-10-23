import 'package:flutter/material.dart';
class MyColumnAndRow extends StatelessWidget{
  const MyColumnAndRow({super.key}); // constructor trùng với class
  // ctrl +  space : ra được override
  // 1. Widget cho tiêu đề của mỗi phần (ví dụ: "Hàng ngang (Row)")
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 2. Widget cho các ô vuông màu sắc trong phần "Hàng ngang"
  Widget _buildColorBox(Color color, IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }

  // 3. Widget cho cái khung xám bao quanh mỗi ví dụ
  Widget _buildSectionContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity, // Mở rộng hết mức có thể
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
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

      // body: Center(
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           const SizedBox(height: 50,),
      //           const Icon(Icons.access_alarm_outlined),
      //           const Icon(Icons.access_alarm_outlined),
      //           const Icon(Icons.access_alarm_outlined)
      //         ],
      //       ),
      //       Row(
      //         children: [
      //           Text("text 1..."),
      //           Text(" text 2 .."),
      //           Text("text 3..."),
      //           Text(" text 4 .."),
      //           Text("text 5..."),
      //           Text(" text 6 .."),
      //         ],
      //       )
      //     ],
      //   ),
      // ),


      body: ListView(
        // Dùng ListView để nội dung có thể cuộn
        padding: const EdgeInsets.all(16.0), // Thêm padding cho toàn bộ body
        children: [
          // --- PHẦN 1: HÀNG NGANG (ROW) ---
          _buildSectionTitle("Hàng ngang (Row)"),
          _buildSectionContainer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn chữ sang trái
              children: [
                const Text("MainAxisAlignment.spaceEvenly:",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorBox(Colors.red, Icons.favorite),
                    _buildColorBox(Colors.green, Icons.eco),
                    _buildColorBox(Colors.blue, Icons.water_drop),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("MainAxisAlignment.spaceBetween:",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildColorBox(Colors.purple, Icons.music_note),
                    _buildColorBox(Colors.orange, Icons.star),
                    _buildColorBox(Colors.teal, Icons.lightbulb),
                  ],
                ),
              ],
            ),
          ),

          // --- PHẦN 2: CỘT DỌC (COLUMN) ---
          _buildSectionTitle("Cột dọc (Column)"),
          _buildSectionContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ví dụ 1: CrossAxisAlignment.start
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn con sang trái
                  children: [
                    const Text("CrossAxisAlignment.start"),
                    const SizedBox(height: 8),
                    Container(
                        width: 100,
                        height: 50,
                        color: Colors.orange,
                        child: const Icon(Icons.airplanemode_active,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                        width: 130,
                        height: 50,
                        color: Colors.orange,
                        child: const Icon(Icons.directions_bike,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                        width: 110,
                        height: 50,
                        color: Colors.red,
                        child: const Icon(Icons.directions_car,
                            color: Colors.white)),
                  ],
                ),
                // Ví dụ 2: CrossAxisAlignment.center
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Căn con vào giữa
                  children: [
                    const Text("CrossAxisAlignment.center"),
                    const SizedBox(height: 8),
                    Container(
                        width: 130,
                        height: 50,
                        color: Colors.blue,
                        child: const Icon(Icons.cloud, color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                        width: 100,
                        height: 50,
                        color: Colors.blue,
                        child: const Icon(Icons.wb_sunny, color: Colors.white)),
                    const SizedBox(height: 8),
                    Container(
                        width: 130,
                        height: 50,
                        color: Colors.blue,
                        child: const Icon(Icons.brightness_4,
                            color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),

          // --- PHẦN 3: BỐ CỤC LỒNG NHAU ---
          _buildSectionTitle("Bố cục lồng nhau"),
          Container(
            height: 100,
            decoration: BoxDecoration(
              // Tạo dải băng cảnh báo
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Colors.yellow, Colors.yellow,
                  Colors.black, Colors.black,
                ],
                stops: const [0.0, 0.25, 0.25, 0.5], // 25% vàng, 25% đen
                tileMode: TileMode.repeated, // Lặp lại dải màu
              ),
            ),
          ),

          // Thêm khoảng đệm ở dưới cùng để không bị FAB che
          const SizedBox(height: 80),
        ],
      ),
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
