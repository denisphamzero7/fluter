// AppNew.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';

import 'app_header.dart';

class AppNew extends StatefulWidget {
  const AppNew({super.key});

  @override
  State<AppNew> createState() => _AppNewState();
}

class _AppNewState extends State<AppNew> {
  // --- DANH SÁCH ẢNH BANNER ---
  final List<Map<String, String>> bannerData = [
    { "image": 'assets/images/banner1.webp', "title": 'Triển lãm "Ánh sáng & Ký ức"', },
    { "image": 'assets/images/banner2.webp', "title": 'Sự kiện khuyến mãi mới', },
    { "image": 'assets/images/banner3.jpg', "title": 'Thông báo quan trọng', }
  ];
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header
        const AppHeader(),
        // Banner
        _buildExhibitionBanner(),
        // Lưới
        _buildDigitalCitizenGrid(),
      ],
    );
  }

  /// 2. HÀM XÂY DỰNG BANNER
  Widget _buildExhibitionBanner() {
    // (Giữ nguyên code của bạn)
    return Container(
      color: Colors.grey[100],
      child: CarouselSlider(
        items: bannerData.map((item) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title']!,
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold,),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text("Xem tất cả", style: TextStyle(color: Colors.blue[700], fontSize: 14, fontWeight: FontWeight.w500,),),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    item['image']!,
                    fit: BoxFit.cover,
                    width: 1000,
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
          aspectRatio: 16 / 10,
          autoPlay: true,
          enlargeCenterPage: false,
          autoPlayInterval: const Duration(seconds: 4),
          viewportFraction: 1.0,
        ),
      ),
    );
  }

  /// 3. HÀM XÂY DỰNG LƯỚI "CÔNG DÂN SỐ"
  Widget _buildDigitalCitizenGrid() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20),),
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Công dân số", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
            children: [
              // ----- SỬA 1: THÊM `null` VÀO CÁC ITEM KHÔNG CÓ LINK -----
              _buildGridItem(Icons.map_outlined, "Bản đồ\nTP.ĐN mới", null),

              // ----- SỬA 2: THÊM HÀNH ĐỘNG VÀO ITEM "CÔNG TY" -----
              _buildGridItem(Icons.check_box, "Công ty", () {
                Navigator.pushNamed(context, '/company');
              }),

              _buildGridItem(Icons.memory_outlined, "Scan cccd", (){
                Navigator.pushNamed(context, '/scanner_cccd');
              }),
              _buildGridItem(Icons.water_drop_outlined, "Theo dõi\nlượng mưa", null),
              _buildGridItem(Icons.waves_outlined, "Mức mưa,\nngập nước", null),
              _buildGridItem(Icons.health_and_safety_outlined, "Kỹ năng\nphòng chống", null),
              _buildGridItem(Icons.edit_note_outlined, "Phản ánh\ngóp ý", null),
              _buildGridItem(Icons.search_outlined, "Tìm kiếm\nđịa điểm", null),
              _buildGridItem(Icons.verified_user_outlined, "Dịch vụ\nBảo mật", null),
              _buildGridItem(Icons.school_outlined, "Giáo dục", null),
              _buildGridItem(Icons.traffic_outlined, "Giao thông\n(VNTraffic)", null),
              _buildGridItem(Icons.apps_outlined, "Tất cả\nDịch vụ", null),
            ],
          ),
        ],
      ),
    );
  }

  /// HÀM HỖ TRỢ CHO LƯỚI
  // ----- SỬA 3: THÊM THAM SỐ `VoidCallback? onTap` -----
  Widget _buildGridItem(IconData icon, String label, VoidCallback? onTap) {
    // ----- SỬA 4: BỌC `Column` BẰNG `InkWell` -----
    return InkWell(
      onTap: onTap, // Gán hành động
      borderRadius: BorderRadius.circular(15), // Bo góc cho hiệu ứng ripple
      child: Column(
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
                color: Colors.blue.shade100,
                width: 1,
              ),
            ),
            child: Icon( icon, size: 30, color: Colors.blue[700], ),
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
      ),
    );
  }
}