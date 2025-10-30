import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';


import '../../network/database_helper.dart';





class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key}); // Thêm constructor const

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  File? _imageFile;
  String _extractedText = "Chưa có dữ liệu";
  CitizenInfo? _parsedInfo;
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // 1. Hàm chọn ảnh
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _extractedText = "Đang xử lý...";
        _parsedInfo = null;
      });
      _processImage(pickedFile.path);
    }
  }

  // 2. Hàm xử lý ảnh bằng ML Kit
  Future<void> _processImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText =
    await _textRecognizer.processImage(inputImage);
    String fullText = recognizedText.text;

    // 3. Phân tích dữ liệu
    CitizenInfo parsedData = _parseCCCD(fullText);

    setState(() {
      _extractedText = fullText;
      _parsedInfo = parsedData;
    });
  }
  CitizenInfo _parseCCCD(String rawText) {
    // Dòng print này vẫn rất quan trọng để gỡ lỗi
    print("--- Dữ liệu thô từ ML Kit ---");
    print(rawText);
    print("-----------------------------");

    // === CÁC MẪU REGEX HOÀN CHỈNH ===

    // 1. Số CCCD: (Giữ nguyên)
    String idNumber =
    _findValue(rawText, r"(?:S0|Số|So|S6I|SáI)[\s\S]*?(?:No)?:?[\s\S]*?(\d{12})");
    if (idNumber == "Không tìm thấy") {
      idNumber = _findValue(rawText, r"(\d{12})"); // Cách dự phòng
    }

    // 2. Họ tên: (Giữ nguyên)
    String fullName =
    _findValue(rawText, r"H[ọo].*?tên[\s\S]*?Ful[l]? name:?[\s\S]*?\n(.*?)(?=\n)");

    // 3. Ngày sinh: (Giữ nguyên)
    String dob = _findValue(
        rawText, r"Ngày sinh[\s\S]*?Date of b[i]?[r]?th:?[\s\S]*?(\d{2}[\/I][\dO]{2}[\/I][\dO]{4})");
    if (dob != "Không tìm thấy") {
      dob = dob.replaceAll('O', '0').replaceAll('I', '/');
    }

    // 4. Giới tính: (Giữ nguyên)
    String sex =
    _findValue(rawText, r"Gi[ớo]i t[íi]nh[\s\S]*?Sex:?[\s\S]*?(Nam|N[ữM])");

    // 5. Quốc tịch: (Giữ nguyên)
    String nationality = _findValue(
        rawText, r"(?:Qu[ốô]c t[l]ch|Nat[i]?onality):?[\s\S]*?(Vi[ệe]t Nam)");

    // 6. Quê quán: (*** SỬA LỖI ***)
    // Nới lỏng điều kiện dừng 'Có giá trị' để khớp với 'Có giá erị'.
    // Chúng ta chỉ cần tìm 'C[óo] gi[áa]' là đủ để dừng.
    String placeOfOrigin = _findValue(rawText,
        r"(?:Quê (?:quán|quan|qun|quận)|Place of (?:origin|ogin|oigin|odgin)):?([\s\S]*?)(?=(?:N[oơ]i (?:thường|thưÒng) (?:tr[úù]|trủ[l]?))|(?:C[óo] gi[áa]))"); // <<< SỬA Ở ĐÂY

    // Dọn dẹp Quê quán (Giữ nguyên logic dọn dẹp của bạn)
    placeOfOrigin = placeOfOrigin
        .replaceAll('\n', ', ')
        .replaceAll(r'trủ', '')
        .replaceAll(r'trú', '')
        .replaceAll(r'\bD\b', '')
        .replaceAll(RegExp(r'[, ]{2,}'), ', ')
        .replaceAll(RegExp(r'^[,\s]+'), '')
        .replaceAll(RegExp(r'[,\s]+$'), '')
        .trim();


    // 7. Nơi thường trú: (*** SỬA LỖI ***)
    // Nới lỏng 'Place of residence' để khớp với 'Place ofesidence'
    String placeOfResidenceRaw = _findValue(rawText,
        r"N[oơ]i (?:thường|thưÒng) (?:tr[úù]|trủ[l]?)[\s\S]*?Place (?:af residence|of residence|ofesidence):?([\s\S]*?)(?=---|$)"); // <<< SỬA Ở ĐÂY

    // (Logic dọn dẹp thông minh của bạn vẫn giữ nguyên, nó rất tốt)
    String placeOfResidence = "Không tìm thấy";
    if (placeOfResidenceRaw != "Không tìm thấy") {
      List<String> lines = placeOfResidenceRaw.split('\n');
      List<String> cleanLines = lines.where((line) {
        String lowerLine = line.toLowerCase().trim();
        if (lowerLine.isEmpty) return false;
        if (lowerLine == 'dón') return false;
        // Thêm 'date of bxpiry' từ log của bạn
        if (lowerLine.contains('date ofixr') || lowerLine.contains('date of') || lowerLine.contains('bxpiry')) return false;
        // Thêm 'Ea Mdhar2' vì nó là rác từ dòng bị gộp
        if (lowerLine.contains('ea mdhar2')) return false;
        return true;
      }).toList();

      placeOfResidence = cleanLines.join(', ');
      placeOfResidence = placeOfResidence
          .replaceAll(RegExp(r'[, ]{2,}'), ', ')
          .replaceAll(RegExp(r'^[,\s]+'), '')
          .replaceAll(RegExp(r'[,\s]+$'), '')
          .trim();
    }


    // 8. Có giá trị đến: (Thêm 'erị' vào key)
    String dateOfExpiry = _findValue(rawText,
        r"(?:C[óo] gi[áa] (?:tr[ịi]|erị) (?:[đđ][ếe]n|đồn)|Date ofexpiry|Date ofxpiry|co glá ut bn):?[\s\S]*?(\d{2}[\/I][\dO]{2}[\/I][\dO]{4})"); // <<< SỬA Ở ĐÂY

    if (dateOfExpiry != "Không tìm thấy") {
      dateOfExpiry = dateOfExpiry.replaceAll('O', '0').replaceAll('I', '/');
    }

    // Trả về đối tượng "chuẩn"
    return CitizenInfo(
      idNumber: idNumber.trim(),
      fullName: fullName.trim(),
      dob: dob.trim(),
      nationality: nationality.trim(),
      placeOfOrigin: placeOfOrigin.trim(), // Đã được sửa
      placeOfResidence: placeOfResidence.trim(), // Đã được sửa
      sex: sex.trim(),
      dateOfExpiry: dateOfExpiry.trim(),

      // Các trường mặt sau, chúng ta không quét, nên gán mặc định
      personalIdentification: 'Không quét',
      dateOfIssue: 'Không quét',
      placeOfIssue: 'Không quét',
    );
  }
// Hàm trợ giúp dùng RegEx (ĐÃ CẬP NHẬT)
  String _findValue(String text, String pattern) {
    final match = RegExp(
      pattern,
      caseSensitive: false, // Không phân biệt hoa thường
      multiLine: true,      // Cho phép ^ và $ khớp với đầu/cuối dòng
      dotAll: true,         // QUAN TRỌNG: Cho phép '.' khớp với ký tự xuống dòng
    ).firstMatch(text);

    // CHỈ trim(), KHÔNG replaceAll('\n', ' ')
    // Chúng ta sẽ xử lý '\n' riêng cho từng trường hợp
    return match?.group(1)?.trim() ?? "Không tìm thấy";
  }

  // 5. Hàm lưu vào database
  Future<void> _saveToDatabase() async {
    if (_parsedInfo != null && mounted) { // Thêm 'mounted' check
      await _dbHelper.insertCitizen(_parsedInfo!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu vào database!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Căn cước công dân'),
        leading: IconButton( // Thêm nút quay lại
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_imageFile != null)
                Image.file(_imageFile!, height: 200)
              else
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Chọn ảnh để quét')),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Thông tin đã phân tích:', style: Theme.of(context).textTheme.headlineSmall),
              if (_parsedInfo != null) ...[
                InfoCard(label: 'Số CCCD', value: _parsedInfo!.idNumber),
                InfoCard(label: 'Họ tên', value: _parsedInfo!.fullName),
                InfoCard(label: 'Ngày sinh', value: _parsedInfo!.dob),
                InfoCard(label: 'Quốc tịch', value: _parsedInfo!.nationality),
                InfoCard(label: 'Quê quán', value: _parsedInfo!.placeOfOrigin),
                InfoCard(label: 'Nơi thường trú', value: _parsedInfo!.placeOfResidence),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveToDatabase,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Lưu vào Database'),
                ),
              ] else
                const Text('Chưa có thông tin...'),
              const SizedBox(height: 24),
              Text('Dữ liệu thô từ ML Kit:', style: Theme.of(context).textTheme.headlineSmall),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[100],
                child: Text(_extractedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget phụ trợ để hiển thị thông tin
class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const InfoCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value)),
          ],
        ),
      ),
    );
  }
}