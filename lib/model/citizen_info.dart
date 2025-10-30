// File: citizen_info.dart

class CitizenInfo {
  final String idNumber;
  final String fullName;
  final String dob;
  final String nationality;
  final String placeOfOrigin;
  final String placeOfResidence;

  CitizenInfo({
    required this.idNumber,
    required this.fullName,
    required this.dob,
    required this.nationality,
    required this.placeOfOrigin,
    required this.placeOfResidence,
  });

  // Hàm để chuyển đổi object thành Map (dùng cho database)
  Map<String, dynamic> toMap() {
    return {
      'idNumber': idNumber,
      'fullName': fullName,
      'dob': dob,
      'nationality': nationality,
      'placeOfOrigin': placeOfOrigin,
      'placeOfResidence': placeOfResidence,
    };
  }
}