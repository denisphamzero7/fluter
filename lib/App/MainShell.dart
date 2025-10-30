// MainShell.dart
import 'package:app_02/App/AppNew.dart';
import 'package:app_02/App/ListViewPage.dart';
import 'package:app_02/App/agency_directory_screen.dart';
import 'package:app_02/App/app_header.dart';
import 'package:app_02/App/emergency_contact_screen.dart';
import 'package:app_02/App/feedback_screen.dart';
import 'package:app_02/App/lookup_screen.dart';
import 'package:app_02/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:app_02/Form/Formbase.dart';
import '../MyTextField2.dart';
import 'discovery_screen.dart'; // Cần cho Header

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Danh sách CÁC TRANG CON (chỉ nội dung)
  static final List<Widget> _danhSachTrang = <Widget>[
    const AppNew(), // Index 0: Trang chủ
    const FeedbackScreen(), // Index 1: Tin tức
    const LookupScreen(),
    const DiscoveryScreen(),
    const EmergencyContactScreen(),
    const AgencyDirectoryScreen(),
    const MyTextField(),
    MyTextField2(),
    FormDemo(),
    const ListViewPage(),
    const Center(child: Text('Trang Tra cứu')), // Index 2
    const Center(child: Text('Trang Giới thiệu')), // Index 3
    const Center(child: Text('Trang Tài khoản')), // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar ẩn, chỉ dùng để tô màu status bar
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 0,
      ),

      // SỬA: Body bây giờ là một Column
      body: Column(
        children: [
          // 1. HEADER CHUNG (Lấy từ AppNew.dart)


          // 2. NỘI DUNG TRANG (thay đổi theo tab)
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _danhSachTrang,
            ),
          ),
        ],
      ),

      // 3. THANH ĐIỀU HƯỚNG CHUNG
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            // SỬA: Dùng icon tin tức và label "Tin tức"
            icon: Icon(Icons.article_outlined),
            label: "Tin tức",
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
}