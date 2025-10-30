// lib/App/app_header.dart

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----- SỬA 1: CHUYỂN SANG STATEFULWIDGET -----
class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();

  // ----- SỬA 2: CUNG CẤP preferredSize CHO APPBAR -----
  // Ước tính chiều cao dựa trên layout của bạn (cần điều chỉnh)
  @override
  Size get preferredSize => const Size.fromHeight(220);
}

class _AppHeaderState extends State<AppHeader> {
  // ----- SỬA 3: THÊM STATE ĐỂ GIỮ TÊN -----
  String _userName = "Đang tải...";

  @override
  void initState() {
    super.initState();
    // Tải tên ngay khi widget được tạo
    _loadUserName();
  }

  // ----- SỬA 4: HÀM TẢI TÊN TỪ SharedPreferences -----
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    // Đọc tên đã lưu, nếu không có, dùng "Khách"
    String? storedName = prefs.getString('userName');

    if (mounted) {
      setState(() {
        _userName = storedName ?? "Khách";
      });
    }
  }

  // ----- SỬA 5: HÀM XỬ LÝ ĐĂNG XUẤT -----
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // Xóa token và tên
    await prefs.remove('token');
    await prefs.remove('userName');

    if (!mounted) return;
    // Quay về trang Login và xóa tất cả màn hình cũ
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
            (Route<dynamic> route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color blueTextColor = Colors.blue.shade800;
    // Lấy chiều cao của status bar
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      // ----- SỬA 6: THÊM PADDING CHO STATUS BAR -----
      padding: EdgeInsets.fromLTRB(16, statusBarHeight + 16, 16, 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          // Thêm đường viền mỏng bên dưới cho đẹp
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))
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
                    'assets/images/logo.png',
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // ----- SỬA 7: HIỂN THỊ TÊN NGƯỜI DÙNG -----
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào,", // Thay vì "DANANG"
                    style: TextStyle(
                      color: blueTextColor.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    _userName, // Hiển thị tên đã tải
                    style: TextStyle(
                      color: blueTextColor,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              // -------------------------------------

              const Spacer(),
              IconButton(
                icon: Icon(Icons.notifications_none,
                    color: blueTextColor, size: 28),
                onPressed: () {
                  // TODO: Thêm hành động cho nút thông báo
                },
              ),

              // ----- SỬA 8: THAY NÚT ACCOUNT BẰNG NÚT LOGOUT -----
              IconButton(
                icon: Icon(Icons.logout, // Đổi icon
                    color: blueTextColor, size: 28),
                onPressed: () {
                  // Hiển thị hộp thoại xác nhận đăng xuất
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Đăng xuất'),
                      content: const Text('Bạn có chắc muốn đăng xuất?'),
                      actions: [
                        TextButton(
                          child: const Text('Hủy'),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        TextButton(
                          child: const Text('Đăng xuất'),
                          onPressed: () {
                            Navigator.of(ctx).pop(); // Đóng dialog
                            _handleLogout(); // Gọi hàm đăng xuất
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              // -------------------------------------
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 20,
            child: Marquee(
              text:
              "ng vận động người dân tháo dỡ các tấm đậy, khơi thông hố thu...",
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
                "27/10/2025", // Cập nhật ngày tháng cho đúng
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
                    style: TextStyle(
                        color: blueTextColor.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.1),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}