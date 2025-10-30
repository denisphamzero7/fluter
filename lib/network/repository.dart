import 'package:app_02/network/base_response.dart';
import 'package:dio/dio.dart';

import '../model/company_response.dart';
import '../model/register_response.dart';
import 'dio_helper.dart';
import '../model/login_response.dart';


class Repository {
  static final DioHelper _dioHelper = DioHelper();

  // URL cho Android Emulator
  static const String _loginUrl = "http://192.168.1.91:8080/api/v1/auth/login";
  static const String _registerUrl = "http://192.168.1.91:8080/api/v1/auth/register";
  static const String _companiesUrl = "http://192.168.1.91:8080/api/v1/companies";

  // Nếu dùng iOS Simulator, bạn có thể dùng localhost:
  // static const String _loginUrl = "http://localhost:8080/api/v1/auth/login";


  /// Hàm đăng nhập mới
  Future<BaseResponse<LoginData>?> login(String email, String password) async {
    var requestBody = {
      'username': email,
      'password': password,
    };

    try {
      var responseData = await _dioHelper.post(
        url: _loginUrl,
        requestBody: requestBody,
        isAuthRequired: false,
      );

      // 3. Parse JSON và trả về
      if (responseData != null) {
        // BƯỚC 2: Dùng BaseResponse.fromJson, giống hệt hàm register
        return BaseResponse.fromJson(
            responseData,
                (json) =>
                LoginData.fromJson(json) // Truyền hàm parse cho LoginData
        );
      }
      return null;
    } catch (e) {
      print("Error in repository login: $e");
      return null;
    }
  }


  // Hàm postApi chung của bạn (nên sửa lại để truyền url và auth)
  Future<dynamic> postApi(String url, Object reqModel,
      {bool isAuthRequired = false}) async {
    var response = await _dioHelper.post(
      url: url, // truyền url vào
      requestBody: reqModel,
      isAuthRequired: isAuthRequired, // truyền auth vào
    );
    return response;
  }

  Future<BaseResponse<RegisteredUserData>?> register({
    required String name,
    required String email,
    required String password,
    required String age,
    required String gender,
    required String address,
    required String phone,
  }) async {
    // 1. Tạo request body (Map)
    var requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'gender': gender,
      'address': address,
      'phone': phone,
    };

    try {
      // 2. Gọi API với đúng Content-Type
      var responseData = await _dioHelper.post(
        url: _registerUrl,
        requestBody: requestBody,
        isAuthRequired: false,
      );

      // 3. Parse JSON và trả về
      if (responseData != null) {
        // Dùng BaseResponse.fromJson và truyền hàm parse cho "RegisteredUserData"
        return BaseResponse.fromJson(
            responseData,
                (json) => RegisteredUserData.fromJson(json)
        );
      }
      return null;
    } catch (e) {
      print("Error in repository register: $e");
      return null;
    }
  }
  Future<BaseResponse<List<Company>>?> getCompanies() async {
    try {
      var responseData = await _dioHelper.get(
        url: _companiesUrl,
        isAuthRequired: false, // <-- Giữ 'true' để gửi token
      );
      print("data (getCompanies)" );

      if (responseData != null) {

        // SỬA 2: Sửa logic parse
        return BaseResponse.fromJson(
            responseData,
            // 'json' ở đây là responseData['data'] (một Map)
                (json) {
              // SỬA LỖI: Lấy list từ key 'data' BÊN TRONG map 'json'
              var list = json['data'] as List;

              // Biến List<dynamic> thành List<Company>
              return list.map((item) => Company.fromJson(item)).toList();
            }
        );
      }
      return null;
    } catch (e) {
      // Lỗi sẽ in ra ở đây
      print("Error in repository getCompanies: $e");
      return null;
    }
  }

  }
