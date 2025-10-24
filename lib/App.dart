import 'package:flutter/material.dart';

// Hàm main để chạy ứng dụng
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Tắt banner "DEBUG"
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

// Mình chuyển thành StatefulWidget để quản lý trạng thái của BottomNavigationBar
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Biến này lưu vị trí mục đang được chọn ở thanh điều hướng dưới
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dùng SafeArea để giao diện không bị đè lên thanh trạng thái (pin, sóng,...)
    return SafeArea(
      child: Scaffold(
        // Đặt màu nền xám nhạt giống trong ảnh
        backgroundColor: Colors.grey[100],

        // Không dùng appBar, vì phần header trong ảnh là một phần của body
        // appBar: AppBar(...),

        // body dùng ListView để nội dung có thể cuộn được
        body: ListView(
          children: [

            // 1. Phần Header màu xanh
            _buildHeader(),

            // 2. Phần Triển lãm "Ánh sáng & Ký ức"
            _buildExhibitionBanner(),

            // 3. Phần "Công dân số" (Và các mục khác bên dưới)
            _buildDigitalCitizenGrid(),

            // --- THÊM CÁC MỤC BÊN DƯỚI (NẾU CÓ) ---
            // Trong ảnh có 12 mục, code của bạn mới có 8
            // Bạn có thể thêm 1 GridView nữa hoặc thêm item vào GridView ở trên
          ],
        ),

        // Không có FloatingActionButton trong ảnh
        // floatingActionButton: FloatingActionButton(...),

        // Thanh điều hướng ở dưới (đã cập nhật 5 mục)
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Trang chủ",
            ),
            BottomNavigationBarItem(
              // ĐỔI: Dùng icon 'apps' giống trong ảnh
              icon: Icon(Icons.apps),
              label: "Khám phá",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Tra cứu",
            ),
            BottomNavigationBarItem(
              // ĐỔI: Dùng icon 'description' hoặc 'info'
              icon: Icon(Icons.description_outlined),
              label: "Giới thiệu",
            ),
            BottomNavigationBarItem(
              // ĐỔI: Dùng icon 'person' (filled)
              icon: Icon(Icons.person),
              label: "Tài khoản",
            ),
          ],
          currentIndex: _selectedIndex,
          // Cần set type là fixed khi có nhiều hơn 3 mục
          type: BottomNavigationBarType.fixed,
          // Màu của mục đang được chọn
          selectedItemColor: Colors.blue[700],
          // Màu của các mục không được chọn
          unselectedItemColor: Colors.grey[600],
          onTap: _onItemTapped,
          // Tắt chữ của mục đang được chọn
          showSelectedLabels: true,
          // Bật chữ của các mục không được chọn
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }

  // ---- CÁC HÀM HỖ TRỢ XÂY DỰNG GIAO DIỆN ----

  /// Xây dựng phần Header (logo, tên app, thời tiết)
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      // Trang trí nền xanh gradient
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hàng 1: Logo, Tên app, Chuông, Profile
          Row(
            children: [
              // Logo
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.shield_moon, color: Colors.blue),
                // Bạn có thể dùng: child: Image.asset('assets/logo.png') nếu có ảnh
              ),
              const SizedBox(width: 12),
              // Tên app
              const Text(
                "DANANG SMART CITY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Spacer đẩy 2 icon qua phải
              const Spacer(),
              // Icon chuông
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {},
              ),
              // Icon profile
              IconButton(
                // ĐỔI: Dùng icon 'account_circle' (filled) cho giống ảnh
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),

          // -----
          // PHẦN CHỮ CHẠY (MARQUEE) BỊ THIẾU
          // Bạn có thể thêm vào đây, ví dụ:
          // Text("ng vận động người dân tháo dỡ các tấm đậy...",
          //   style: TextStyle(color: Colors.white.withOpacity(0.9)),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          // const SizedBox(height: 16),
          // -----

          // Hàng 2: Vị trí và Ngày
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              const Text(
                "Thành phố Đà Nẵng",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text(
                "24/10/2025",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Hàng 3: Thời tiết
          Row(
            children: [
              const Icon(Icons.cloud_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Text(
                "26°C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Mây cụm",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Xây dựng phần Banner triển lãm
  Widget _buildExhibitionBanner() {
    // Cấu trúc code này của bạn đã ĐÚNG
    // Banner trong ảnh là một file ảnh ĐÃ CÓ SẴN CHỮ.
    // Bạn chỉ cần thay 'Image.network' bằng 'Image.asset'
    // trỏ đến đúng file ảnh banner là sẽ giống.

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tiêu đề "Triển lãm..."
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Triển lãm \"Ánh sáng & Ký ức\"",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Xem tất cả",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Banner
          Card(
            // Bỏ viền mặc định
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias, // Cắt ảnh theo bo góc
            child: AspectRatio(
              aspectRatio: 16 / 7,
              // Dùng ảnh mạng làm placeholder, bạn có thể thay bằng Image.asset
              child: Image.network(
                'https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2020/03/hoi-an-ve-dem-lung-linh.jpg',
                fit: BoxFit.cover,
                // VÍ DỤ: Dùng ảnh local
                // child: Image.asset(
                //   'assets/images/banner_trienlam.png',
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Xây dựng lưới "Công dân số"
  Widget _buildDigitalCitizenGrid() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "Công dân số"
          const Text(
            "Công dân số",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Dùng GridView.count để tạo lưới 4 cột
          GridView.count(
            crossAxisCount: 4, // 4 cột
            shrinkWrap: true, // Co lại để vừa với nội dung
            // Tắt cuộn của GridView (để ListView chính cuộn)
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
            children: [
              // Gọi hàm tạo item cho mỗi mục
              // LƯU Ý: Trong ảnh là dùng HÌNH ẢNH, không phải ICON
              // Xem giải thích bên dưới
              _buildGridItem(Icons.map_outlined, "Bản đồ\nTP.ĐN mới"),
              _buildGridItem(Icons.flood_outlined, "Bản đồ\nmưa ngập"),
              _buildGridItem(Icons.memory, "Danang AI"),
              _buildGridItem(Icons.water_drop_outlined, "Theo dõi\nlượng mưa"),
              _buildGridItem(Icons.waves_outlined, "Mức mưa,\nngập nước"),
              _buildGridItem(Icons.health_and_safety_outlined, "Kỹ năng\nphòng chống"),
              _buildGridItem(Icons.edit_note_outlined, "Phản ánh\ngóp ý"),
              _buildGridItem(Icons.search_outlined, "Tìm kiếm\nđịa điểm"),
              // Trong ảnh có 12 mục, bạn có thể thêm 4 mục nữa ở đây
              _buildGridItem(Icons.verified_user_outlined, "Dịch vụ\nBảo mật"),
              _buildGridItem(Icons.school_outlined, "Giáo dục"),
              _buildGridItem(Icons.traffic_outlined, "Giao thông\n(VNTraffic)"),
              _buildGridItem(Icons.apps, "Tất cả\nDịch vụ"),
            ],
          ),
        ],
      ),
    );
  }

  /// Hàm nhỏ để xây dựng 1 ô trong lưới (gồm icon và chữ)
  Widget _buildGridItem(IconData icon, String label) {
    return Column(
      // Canh giữa theo chiều dọc
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Nền của icon
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // ĐỔI: Dùng màu xanh nhạt E0F7FA (lightBlue[50])
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(15),
            // Bỏ bóng mờ (shadow) và dùng viền (border)
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.1),
            //     spreadRadius: 1,
            //     blurRadius: 3,
            //     offset: const Offset(0, 2),
            //   ),
            // ],
            // THÊM: Viền mỏng màu xanh nhạt
            border: Border.all(color: Colors.blue.shade100, width: 1),
          ),
          // Icon
          child: Icon(
            icon,
            color: Colors.blue[700],
            size: 30,
          ),
        ),
        const SizedBox(height: 6),
        // Chữ
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center, // Canh giữa chữ
            style: const TextStyle(fontSize: 12, height: 1.3),
            // Giới hạn 2 dòng chữ
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}