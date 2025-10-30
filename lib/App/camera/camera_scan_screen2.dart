import 'dart:io';
import 'dart:typed_data'; // <<< THÊM IMPORT NÀY
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // <<< THÊM IMPORT NÀY

import '../../network/database_helper.dart'; // Đảm bảo đường dẫn này đúng

// (Class CitizenInfo của bạn ở đây...)

class CameraScanScreen extends StatefulWidget {
  const CameraScanScreen({super.key});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  File? _imageFile;
  String _extractedText = "Chưa có dữ liệu";
  CitizenInfo? _parsedInfo;

  // SỬA LỖI 1: Sửa 'Image.picker()' thành 'ImagePicker()'
  final ImagePicker _picker = ImagePicker();

  final TextRecognizer _textRecognizer =
  TextRecognizer(script: TextRecognitionScript.latin);
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // SỬA LỖI 2: Xóa 'final DocumentScanner _documentScanner' ở đây
  // Nó là một Widget, không phải là một controller

  // --- LOGIC XỬ LÝ ĐÃ CẬP NHẬT ---

  // 1. HÀM MỚI: Quét bằng Camera (ĐÃ SỬA LỖI API)
  Future<void> _scanFromCamera() async {
    try {
      // SỬA LỖI 3: Dùng Navigator.push để mở DocumentScanner
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentScanner(
            // onSave là callback BẮT BUỘC, trả về Uint8List
            onSave: (Uint8List imageBytes) async {

              // 1. Lấy đường dẫn thư mục tạm
              final directory = await getTemporaryDirectory();
              final String filePath = '${directory.path}/scanned_image.jpg';

              // 2. Tạo một File từ đường dẫn
              final File scannedImage = File(filePath);

              // 3. Ghi dữ liệu bytes vào file
              await scannedImage.writeAsBytes(imageBytes);

              // 4. Pop màn hình quét (quay lại màn hình chính)
              Navigator.pop(context);

              // 5. Cập nhật UI và xử lý ảnh
              // (Phải check `mounted` vì đây là 1 callback)
              if (mounted) {
                setState(() {
                  _imageFile = scannedImage;
                  _extractedText = "Đang xử lý ảnh đã làm phẳng...";
                  _parsedInfo = null;
                });
                _processImage(scannedImage.path);
              }
            },
          ),
        ),
      );
    } catch (e) {
      print("Lỗi khi quét: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi quét tài liệu: $e")),
        );
      }
    }
  }


  // 2. HÀM CŨ (Đổi tên): Chỉ dùng để chọn từ Gallery (Không làm phẳng)
  Future<void> _pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _extractedText = "Đang xử lý ảnh từ Gallery...";
        _parsedInfo = null;
      });
      _processImage(pickedFile.path);
    }
  }

  // 3. Hàm xử lý ảnh (Giữ nguyên logic V4)
  Future<void> _processImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText =
    await _textRecognizer.processImage(inputImage);
    CitizenInfo parsedData = _parseCCCD_V4(recognizedText);
    setState(() {
      _extractedText = recognizedText.text;
      _parsedInfo = parsedData;
    });
  }

  // 4. HÀM PHÂN TÍCH V4 (Giữ nguyên)
  CitizenInfo _parseCCCD_V4(RecognizedText recognizedText) {
    final List<TextLine> allLines =
    recognizedText.blocks.expand((block) => block.lines).toList();
    allLines.sort((a, b) {
      final int topCompare = a.boundingBox.top.compareTo(b.boundingBox.top);
      if (topCompare.abs() > 8) return topCompare;
      return a.boundingBox.left.compareTo(b.boundingBox.left);
    });

    print("--- Các dòng đã sắp xếp (Từ ảnh đã làm phẳng) ---");
    final allLineTexts = allLines.map((l) => l.text).toList();
    print(allLineTexts.join('\n'));
    print("-------------------------------------------------");

    Map<String, String> results = {
      'id': "Không tìm thấy",
      'fullName': "Không tìm thấy",
      'dob': "Không tìm thấy",
      'sex': "Không tìm thấy",
      'nationality': "Không tìm thấy",
      'origin': "Không tìm thấy",
      'residence': "Không tìm thấy",
      'expiry': "Không tìm thấy",
    };

    final RegExp idPattern = RegExp(r"(\d{12})");
    final RegExp dobPattern = RegExp(r"(\d{2}[\/I1lr][\dO]{2}[\/I1lr][\dO1]{4})");
    final RegExp sexPattern = RegExp(r"(Nam|Nữ|NARI)");
    final RegExp nationPattern = RegExp(r"(Việt Nam)");

    int originStartIndex = -1;
    int residenceStartIndex = -1;
    int expiryStartIndex = -1;

    for (int i = 0; i < allLines.length; i++) {
      String lineText = allLines[i].text;
      String lowerLineText = lineText.toLowerCase();

      if (lowerLineText.contains("số / no") || lowerLineText.contains("sói")) {
        final match = idPattern.firstMatch(lineText);
        if (match != null) results['id'] = match.group(1)!;
      }
      if (lowerLineText.contains("ngày sinh")) {
        final match = dobPattern.firstMatch(lineText);
        if (match != null) results['dob'] = match.group(1)!;
      }
      if (lowerLineText.contains("giới tính") ||
          lowerLineText.contains("quốc tịch")) {
        if (results['sex'] == "Không tìm thấy") {
          final match = sexPattern.firstMatch(lineText);
          if (match != null) results['sex'] = match.group(1)!;
        }
        if (results['nationality'] == "Không tìm thấy") {
          final match = nationPattern.firstMatch(lineText);
          if (match != null) results['nationality'] = match.group(1)!;
        }
      }
      if (lowerLineText.contains("họ và tên") && (i + 1) < allLines.length) {
        results['fullName'] = allLines[i + 1].text;
      }
      if (lowerLineText.contains("có giá trị đến") ||
          lowerLineText.contains("co giá trj đón")) {
        expiryStartIndex = i;
      }
      if (lowerLineText.contains("quê quán") ||
          lowerLineText.contains("quận pace of")) {
        originStartIndex = i;
      }
      if (lowerLineText.contains("nơi thường trú") ||
          lowerLineText.contains("noii thường trủ")) {
        residenceStartIndex = i;
      }
    }

    if (expiryStartIndex != -1) {
      var match = dobPattern.firstMatch(allLines[expiryStartIndex].text);
      if (match != null) {
        results['expiry'] = match.group(1)!;
      } else if (expiryStartIndex + 1 < allLines.length) {
        match = dobPattern.firstMatch(allLines[expiryStartIndex + 1].text);
        if (match != null) results['expiry'] = match.group(1)!;
      }
    }
    if (originStartIndex != -1) {
      results['origin'] = _extractMultiLineValue(allLines, originStartIndex,
          residenceStartIndex, r"(quê quán|quận pace of)(.*)");
    }
    if (residenceStartIndex != -1) {
      results['residence'] = _extractMultiLineValue(allLines,
          residenceStartIndex, expiryStartIndex, r"(nơi thường trú|noii thường trủ)(.*)");
    }

    final String Function(String) cleanDate = (date) => date
        .replaceAll('O', '0')
        .replaceAll('I', '/')
        .replaceAll('l', '/')
        .replaceAll('r', '/');
    final String Function(String) cleanSex =
        (sex) => sex.replaceAll("NARI", "Nam");

    return CitizenInfo(
      idNumber: results['id']!.trim(),
      fullName: results['fullName']!.trim(),
      dob: cleanDate(results['dob']!.trim()),
      nationality: results['nationality']!.trim(),
      placeOfOrigin: results['origin']!.replaceAll('\n', ', ').trim(),
      placeOfResidence: results['residence']!.replaceAll('\n', ', ').trim(),
      sex: cleanSex(results['sex']!.trim()),
      dateOfExpiry: cleanDate(results['expiry']!.trim()),
      personalIdentification: 'Không quét',
      dateOfIssue: 'Không quét',
      placeOfIssue: 'Không quét',
    );
  }

  // Hàm trợ giúp cho V4 (Giữ nguyên)
  String _extractMultiLineValue(
      List<TextLine> lines, int startIndex, int endIndex, String keyPattern) {
    List<String> results = [];
    final String firstLineText = lines[startIndex].text;
    final match =
    RegExp(keyPattern, caseSensitive: false).firstMatch(firstLineText);
    if (match != null && match.group(2) != null) {
      String firstLineValue = match.group(2)!.trim();
      if (firstLineValue.startsWith(':')) {
        firstLineValue = firstLineValue.substring(1).trim();
      }
      if (firstLineValue.isNotEmpty) {
        results.add(firstLineValue);
      }
    }
    int effectiveEndIndex;
    if (endIndex != -1 && endIndex > startIndex) {
      effectiveEndIndex = endIndex;
    } else {
      effectiveEndIndex = (startIndex + 3).clamp(0, lines.length);
    }
    int currentIndex = startIndex + 1;
    while (currentIndex < effectiveEndIndex) {
      results.add(lines[currentIndex].text);
      currentIndex++;
    }
    return results.join(", ");
  }

  // 5. Hàm lưu vào database (Giữ nguyên)
  Future<void> _saveToDatabase() async {
    if (_parsedInfo != null && mounted) {
      await _dbHelper.insertCitizen(_parsedInfo!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu vào database!')),
      );
    }
  }

  // --- GIAO DIỆN (Giữ nguyên) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Căn cước công dân'),
        leading: IconButton(
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
                    onPressed: _scanFromCamera, // Sẽ gọi hàm đã sửa
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: const Icon(Icons.image),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Thông tin đã phân tích:',
                  style: Theme.of(context).textTheme.headlineSmall),
              if (_parsedInfo != null) ...[
                InfoCard(label: 'Số CCCD', value: _parsedInfo!.idNumber),
                InfoCard(label: 'Họ tên', value: _parsedInfo!.fullName),
                InfoCard(label: 'Ngày sinh', value: _parsedInfo!.dob),
                InfoCard(label: 'Giới tính', value: _parsedInfo!.sex),
                InfoCard(label: 'Quốc tịch', value: _parsedInfo!.nationality),
                InfoCard(label: 'Quê quán', value: _parsedInfo!.placeOfOrigin),
                InfoCard(
                    label: 'Nơi thường trú',
                    value: _parsedInfo!.placeOfResidence),
                InfoCard(
                    label: 'Hạn sử dụng', value: _parsedInfo!.dateOfExpiry),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveToDatabase,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Lưu vào Database'),
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(child: Text('Chưa có thông tin...')),
                ),
              const SizedBox(height: 24),
              Text('Dữ liệu thô từ ML Kit:',
                  style: Theme.of(context).textTheme.headlineSmall),
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

// Widget phụ trợ để hiển thị thông tin (Giữ nguyên)
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    ),
  );
}
}