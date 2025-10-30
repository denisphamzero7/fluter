// lib/App/login.dart

import 'package:app_02/App/MainShell.dart';
import 'package:app_02/App/auth/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SỬA 1: Import BaseResponse
import 'package:app_02/network/base_response.dart';
// SỬA 2: Import LoginData (từ file login_response.dart cũ)
import 'package:app_02/model/login_response.dart';
import 'package:app_02/network/repository.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repository = Repository();
  bool _isLoading = false;
  bool _obscureText = true; // Thêm để ẩn/hiện password

  @override
  void initState() {
    super.initState();
    // Điền sẵn để test cho nhanh (giống Postman)
    _emailController.text = 'phuong123@gmail.com';
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // SỬA 3: Cập nhật toàn bộ hàm _handleLogin
  Future<void> _handleLogin() async {
    setState(() { _isLoading = true; });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // SỬA 4: Dùng BaseResponse<LoginData>
      BaseResponse<LoginData>? response = await _repository.login(email, password);

      if (!mounted) return;

      // SỬA 5: Kiểm tra response (dùng 200 hoặc 201 cho chắc)
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {

        print('Login successful!');
        print('User Name: ${response.data.user.name}');

        // ----- SỬA 6: LƯU TOKEN VÀ TÊN NGƯỜI DÙNG -----
        final prefs = await SharedPreferences.getInstance();

        // Lưu token để AuthCheckScreen có thể đọc
        await prefs.setString('token', response.data.accessToken);

        // Lưu tên để AppHeader có thể đọc
        await prefs.setString('userName', response.data.user.name);

        // (Không cần lưu refresh_token trừ khi bạn dùng nó)
        // await prefs.setString('refresh_token', response.data.refreshToken);

        // ĐĂNG NHẬP THÀNH CÔNG -> ĐI THẲNG VÀO HOME
        // Không cần SnackBar, vì AppHeader sẽ chào họ
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainShell()),
        );

      } else {
        // ĐĂNG NHẬP THẤT BẠI
        final message = response?.message ?? 'Đăng nhập thất bại. Vui lòng thử lại.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // LỖI (ví dụ: mất mạng, parse JSON lỗi)
      print('An error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _goToRegister() {
    // Đi đến trang đăng ký (đảm bảo bạn đã có '/register' trong routes ở main.dart)
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegisterScreen())
    );
  }

  // SỬA 7: LÀM LẠI GIAO DIỆN (BUILD)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bỏ AppBar để giao diện thoáng hơn
      body: SafeArea(
        child: Center(
          // Dùng SingleChildScrollView để tránh lỗi khi bàn phím hiện lên
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              // Giới hạn chiều rộng trên màn hình lớn (máy tính bảng)
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icon
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 80,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(height: 24),
                  // Tiêu đề
                  Text(
                    'Đăng nhập',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // TextField Email
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Username (Email)',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // TextField Password
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Thêm nút ẩn/hiện password
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                  const SizedBox(height: 32),
                  // Nút Đăng nhập
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    height: 50, // Chiều cao chuẩn cho nút
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Nút Đăng ký
                  TextButton(
                    onPressed: _goToRegister,
                    child: Text(
                      'Chưa có tài khoản? Đăng ký ngay',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}