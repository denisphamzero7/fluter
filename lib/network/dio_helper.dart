// dio_helper.dart
import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart'; // <-- 1. IMPORT
import 'injection_container.dart';

class DioHelper {
  Dio dio = getDio();

  Options options = Options(
      receiveDataWhenStatusError: true,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30)
  );

  // SỬA 2: XÓA MAP "headers" BỊ VIẾT CỨNG Ở ĐÂY
  // Map <String, dynamic> headers = { ... }; // <-- XÓA CÁI NÀY

  // SỬA 3: HÀM NÀY SẼ TỰ ĐỘNG LẤY TOKEN MỚI NHẤT
  Future<Options> _getOptionsWithAuth(bool isAuthRequired) async {
    Options requestOptions = options.copyWith();

    // Thêm header auth nếu được yêu cầu
    if (isAuthRequired) {
      // 3.1. Đọc token thật từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      // Dùng key 'token' (giống hệt lúc bạn lưu ở login_screen.dart)
      final String? token = prefs.getString('token');

      // 3.2. Gán header
      requestOptions.headers = {
        "Authorization": 'Bearer $token', // Gửi token thật
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
    }
    return requestOptions;
  }

  // GET API
  Future<dynamic> get({required String url, bool isAuthRequired = false}) async {
    try {
      // SỬA 4: Lấy options đã có token
      Options requestOptions = await _getOptionsWithAuth(isAuthRequired);

      Response response = await dio.get(url, options: requestOptions);
      return response.data;
    } catch (error) {
      return null;
    }
  }

  // POST API
  Future<dynamic> post({required String url, Object? requestBody, bool isAuthRequired = false}) async {
    try {
      // SỬA 5: Lấy options đã có token
      Options requestOptions = await _getOptionsWithAuth(isAuthRequired);

      // Chỉ đặt contentType là JSON nếu requestBody KHÔNG PHẢI là FormData
      if (requestBody is! FormData) {
        requestOptions.contentType = "application/json";
      }

      Response  response;
      if (requestBody == null) {
        response = await dio.post(url, options: requestOptions);
      } else {
        response = await dio.post(url, data: requestBody, options: requestOptions);
      }
      return response.data;
    } on DioException catch (e) {
      return null;
    } catch (error) {
      return null;
    }
  }
}