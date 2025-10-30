import 'package:flutter/material.dart';
import '../../../network/repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _repository = Repository();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Key để validate form
  bool _isPasswordObscure = true; // Biến để ẩn/hiện mật khẩu

  // 7 controllers cho 7 trường
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // 1. Validate form
    if (!_formKey.currentState!.validate()) {
      return; // Nếu form không hợp lệ, dừng lại
    }

    setState(() { _isLoading = true; });

    try {
      // 2. Gọi hàm register mới từ repository
      var response = await _repository.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        age: _ageController.text.trim(),
        gender: _genderController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (!mounted) return;

      if (response != null) {
        // ĐĂNG KÝ THÀNH CÔNG
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập.'),
            backgroundColor: Colors.green,
          ),
        );
        // Tự động quay lại trang đăng nhập
        Navigator.of(context).pop();

      } else {
        // ĐĂNG KÝ THẤT BẠI
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thất bại. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // LỖI
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

  // Hàm helper cho validator (đơn giản)
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng không để trống';
    }
    return null;
  }

  // ----- HÀM MỚI: Helper để build TextFormField cho đồng bộ -----
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ----- HÀM MỚI: Helper cho ô mật khẩu (vì có suffixIcon) -----
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      validator: _validateNotEmpty,
      obscureText: _isPasswordObscure, // Dùng biến state
      decoration: InputDecoration(
        labelText: 'Mật khẩu (Password)',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscure = !_isPasswordObscure;
            });
          },
        ),
      ),
    );
  }

  // ----- HÀM MỚI: Helper cho link "Đăng nhập" -----
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Đã có tài khoản? "),
        GestureDetector(
          onTap: () {
            // Quay lại trang trước đó (trang Đăng nhập)
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Đăng nhập ngay",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      // Bỏ AppBar
      // appBar: AppBar(title: Text('Đăng ký tài khoản')),
      body: SafeArea( // Thêm SafeArea
        child: Center( // Thêm Center
          child: Container(
            // Giới hạn chiều rộng cho tablet
            constraints: BoxConstraints(maxWidth: 600),
            child: Form( // Bọc trong Form
              key: _formKey,
              child: ListView( // Dùng ListView để tránh lỗi tràn màn hình
                padding: const EdgeInsets.symmetric(horizontal: 24.0), // Thêm padding
                children: [
                  SizedBox(height: 30),
                  // Thêm Icon giống Login
                  Icon(
                    Icons.person_add_outlined, // Đổi Icon cho phù hợp
                    size: 80,
                    color: Colors.blue[700],
                  ),
                  SizedBox(height: 16),
                  // Thêm Tiêu đề giống Login
                  Text(
                    'Tạo tài khoản',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Dùng helper để tạo các ô nhập liệu
                  _buildTextField(
                    controller: _nameController,
                    label: 'Tên (Name)',
                    icon: Icons.person_outline,
                    validator: _validateNotEmpty,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    validator: _validateNotEmpty,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),

                  // Dùng helper riêng cho mật khẩu
                  _buildPasswordField(),

                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _ageController,
                    label: 'Tuổi (Age)',
                    icon: Icons.cake_outlined,
                    validator: _validateNotEmpty,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _genderController,
                    label: 'Giới tính (Gender)',
                    icon: Icons.wc_outlined,
                    validator: _validateNotEmpty,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Địa chỉ (Address)',
                    icon: Icons.home_outlined,
                    validator: _validateNotEmpty,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Số điện thoại (Phone)',
                    icon: Icons.phone_outlined,
                    validator: _validateNotEmpty,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 32),

                  // Nút Đăng ký
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: _handleRegister,
                    // Thêm Style cho nút
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700]     ,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Đăng ký', style: TextStyle(fontSize: 16)),
                  ),

                  SizedBox(height: 24),

                  // Thêm link quay lại Đăng nhập
                  _buildLoginLink(),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}