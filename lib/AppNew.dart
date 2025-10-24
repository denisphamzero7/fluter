import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Dùng cho status bar
import 'package:carousel_slider/carousel_slider.dart'; // Dùng cho banner
import 'package:marquee/marquee.dart'; // Dùng cho chữ chạy

// Đảm bảo bạn đã cài đặt:
// flutter pub add carousel_slider
// flutter pub add marquee

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AppNew(),
  ));
}

class AppNew extends StatefulWidget {
  const AppNew({super.key});

  @override
  State<AppNew> createState() => _AppNewState();
}

class _AppNewState extends State<AppNew> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- DANH SÁCH ẢNH BANNER ---
  final List<Map<String, String>> bannerData = [
    {
      "image": 'assets/images/banner1.webp',
      "title": 'Triển lãm "Ánh sáng & Ký ức"',
    },
    {
      "image": 'assets/images/banner2.webp',
      "title": 'Sự kiện khuyến mãi mới', // Title ví dụ
    },
    {
      "image": 'assets/images/banner3.jpg',
      "title": 'Thông báo quan trọng', // Title ví dụ
    }
  ];
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    // SỬA: XÓA "SafeArea" bọc ngoài. Return Scaffold trực tiếp.
    return Scaffold(
      backgroundColor: Colors.grey[100],

      // SỬA: Dùng AppBar để tô màu xanh cho status bar
      appBar: AppBar(
        // Đặt màu nền cho AppBar VÀ status bar
        backgroundColor: Colors.blue[700],
        // Tắt bóng mờ (shadow) bên dưới AppBar
        elevation: 0,
        // Đảm bảo icon status bar (pin, sóng) có màu TRẮNG
        systemOverlayStyle: SystemUiOverlayStyle.light,
        // Đặt chiều cao = 0 để AppBar vô hình, chỉ để tô màu
        toolbarHeight: 0,
      ),

      // Body là ListView
      body: ListView(
        // Tắt padding mặc định ở trên cùng
        padding: EdgeInsets.zero,
        children: [
          // Header (nền TRẮNG, chữ XANH)
          _buildHeader(),

          // Banner
          _buildExhibitionBanner(),

          // Lưới
          _buildDigitalCitizenGrid(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: "Khám phá",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Tra cứu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: "Giới thiệu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Tài khoản",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }

  // ---- CÁC HÀM HỖ TRỢ ĐỂ BUILD GIAO DIỆN ----

  /// 1. HÀM XÂY DỰNG HEADER (NỀN TRẮNG, CHỮ XANH)
  Widget _buildHeader() {
    // Định nghĩa màu chữ xanh
    final Color blueTextColor = Colors.blue.shade800;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      // Nền màu TRẮNG
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[50],
                radius: 22,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/images/logo.png', // <-- THAY BẰNG LOGO CỦA BẠN
                    errorBuilder: (context, error, stackTrace) {
                      // Hiển thị lỗi nếu không tìm thấy logo
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DANANG",
                    style: TextStyle(
                      color: blueTextColor,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "SMART CITY",
                    style: TextStyle(
                      color: blueTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.notifications_none, color: blueTextColor, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_circle, color: blueTextColor, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 20,
            child: Marquee(
              text: "ng vận động người dân tháo dỡ các tấm đậy, khơi thông hố thu...",
              style: TextStyle(color: blueTextColor.withOpacity(0.9), fontSize: 14),
              velocity: 35.0,
              blankSpace: 20.0,
              pauseAfterRound: const Duration(seconds: 1),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.location_on, color: blueTextColor, size: 18),
              const SizedBox(width: 4),
              Text(
                "Thành phố Đà Nẵng",
                style: TextStyle(color: blueTextColor, fontSize: 14),
              ),
              const Spacer(),
              Icon(Icons.calendar_today, color: blueTextColor, size: 16),
              const SizedBox(width: 4),
              Text(
                "24/10/2025",
                style: TextStyle(color: blueTextColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.cloud_outlined, color: blueTextColor, size: 32),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "26°C",
                    style: TextStyle(
                      color: blueTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    "Mây cụm",
                    style: TextStyle(color: blueTextColor.withOpacity(0.9), fontSize: 16, height: 1.1),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  /// 2. HÀM XÂY DỰNG BANNER
  /// 2. HÀM XÂY DỰNG BANNER (KHÔNG STACK, KHÔNG CỐ ĐỊNH)
  Widget _buildExhibitionBanner() {
    return Container(
      // SỬA: Nền của carousel là màu xám nhạt
      color: Colors.grey[100],
      child: CarouselSlider(
        // Dùng `bannerData`
        items: bannerData.map((item) {
          // `item` là một Map: {"image": "...", "title": "..."}
          return Container( // SỬA: Dùng Container thay vì Card
            // margin: const EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white, // Nền trắng cho cả slide
            child: Column( // Dùng Column: Chữ ở trên, ảnh ở dưới
              children: [

                // PHẦN 1: CHỮ (NỀN TRẮNG)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cột chứa Title
                      Expanded(
                        child: Text(
                          item['title']!, // Lấy title từ Map
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Chữ "Xem tất cả"
                      Text(
                        "Xem tất cả",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // PHẦN 2: ẢNH (KHÔNG CÓ PADDING)
                Expanded( // Dùng Expanded để ảnh lấp đầy phần còn lại
                  child: Image.asset(
                    item['image']!, // Lấy đường dẫn ảnh
                    fit: BoxFit.cover,
                    width: 1000, // Đảm bảo ảnh rộng hết
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        options: CarouselOptions(
          // SỬA: Tỷ lệ cao hơn để chứa cả chữ (16/10)
          aspectRatio: 16 / 10,
          autoPlay: true,
          enlargeCenterPage: false, // SỬA: Tắt phóng to
          autoPlayInterval: const Duration(seconds: 4),
          viewportFraction: 1.0, // SỬA: Hiển thị full-width
        ),
      ),
    );
  }

  /// 3. HÀM XÂY DỰNG LƯỚI "CÔNG DÂN SỐ"
  Widget _buildDigitalCitizenGrid() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Công dân số",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
            children: [
              // (Thay bằng tên file ảnh icon của bạn)
              // SỬA: Quay lại dùng IconData thay vì đường dẫn ảnh
              _buildGridItem(Icons.map_outlined, "Bản đồ\nTP.ĐN mới"),
              _buildGridItem(Icons.flood_outlined, "Bản đồ\nmưa ngập"),
              _buildGridItem(Icons.memory_outlined, "Danang AI"), // Icon ví dụ
              _buildGridItem(Icons.water_drop_outlined, "Theo dõi\nlượng mưa"),
              _buildGridItem(Icons.waves_outlined, "Mức mưa,\nngập nước"),
              _buildGridItem(Icons.health_and_safety_outlined, "Kỹ năng\nphòng chống"),
              _buildGridItem(Icons.edit_note_outlined, "Phản ánh\ngóp ý"),
              _buildGridItem(Icons.search_outlined, "Tìm kiếm\nđịa điểm"),
              _buildGridItem(Icons.verified_user_outlined, "Dịch vụ\nBảo mật"),
              _buildGridItem(Icons.school_outlined, "Giáo dục"),
              _buildGridItem(Icons.traffic_outlined, "Giao thông\n(VNTraffic)"),
              _buildGridItem(Icons.apps_outlined, "Tất cả\nDịch vụ"),
            ],
          ),
        ],
      ),
    );
  }


  /// HÀM HỖ TRỢ CHO LƯỚI
  Widget _buildGridItem(IconData icon, String label) { // <-- SỬA "String imagePath" thành "IconData icon"
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.blue.shade100, // <-- Sửa màu này (ví dụ: Colors.red)
              width: 1, // Độ dày của viền
            ),
          ),
          child: Icon( // Dùng Icon
            icon, // <-- Giờ biến 'icon' này đã tồn tại và đúng kiểu
            size: 30, // Kích cỡ icon
            color: Colors.blue[700], // Màu của icon
          ),
        ),
        const SizedBox(height: 6),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}