// database_helper.dart
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

// 1. Model CitizenInfo (Đã cập nhật "chuẩn")
class CitizenInfo {
  final String idNumber;
  final String fullName;
  final String dob; // Date of birth
  final String nationality;
  final String placeOfOrigin;
  final String placeOfResidence;

  // --- CÁC TRƯỜNG BỔ SUNG TỪ HÌNH ẢNH ---
  final String sex;
  final String dateOfExpiry;

  // --- CÁC TRƯỜNG MẶT SAU (ĐỂ MODEL ĐẦY ĐỦ) ---
  final String personalIdentification; // Đặc điểm nhận dạng
  final String dateOfIssue;          // Ngày cấp
  final String placeOfIssue;         // Nơi cấp

  CitizenInfo({
    required this.idNumber,
    required this.fullName,
    required this.dob,
    required this.nationality,
    required this.placeOfOrigin,
    required this.placeOfResidence,
    // Thêm các trường mới vào constructor
    required this.sex,
    required this.dateOfExpiry,
    required this.personalIdentification,
    required this.dateOfIssue,
    required this.placeOfIssue,
  });

  Map<String, dynamic> toMap() {
    return {
      'idNumber': idNumber,
      'fullName': fullName,
      'dob': dob,
      'nationality': nationality,
      'placeOfOrigin': placeOfOrigin,
      'placeOfResidence': placeOfResidence,
      // Thêm các trường mới vào map
      'sex': sex,
      'dateOfExpiry': dateOfExpiry,
      'personalIdentification': personalIdentification,
      'dateOfIssue': dateOfIssue,
      'placeOfIssue': placeOfIssue,
    };
  }

  // SỬA LỖI MÀN HÌNH ĐỎ: Thêm factory 'fromMap'
  // Nó sẽ xử lý lỗi 'Null' bằng cách gán giá trị mặc định '??'
  factory CitizenInfo.fromMap(Map<String, dynamic> map) {
    return CitizenInfo(
      idNumber: map['idNumber'] ?? '',
      fullName: map['fullName'] ?? '',
      dob: map['dob'] ?? '',
      nationality: map['nationality'] ?? '',
      placeOfOrigin: map['placeOfOrigin'] ?? '',
      placeOfResidence: map['placeOfResidence'] ?? '',
      sex: map['sex'] ?? '',
      dateOfExpiry: map['dateOfExpiry'] ?? '',
      personalIdentification: map['personalIdentification'] ?? '',
      dateOfIssue: map['dateOfIssue'] ?? '',
      placeOfIssue: map['placeOfIssue'] ?? '',
    );
  }
}

// 2. Tạo Database Helper (Đã cập nhật)
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'citizen.db');
    return await openDatabase(
      path,
      version: 2, // Nếu bạn đã chạy app, hãy tăng lên 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Thêm hàm onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE citizens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idNumber TEXT,
        fullName TEXT,
        dob TEXT,
        nationality TEXT,
        placeOfOrigin TEXT,
        placeOfResidence TEXT,
        
        -- Thêm các cột mới --
        sex TEXT,
        dateOfExpiry TEXT,
        personalIdentification TEXT,
        dateOfIssue TEXT,
        placeOfIssue TEXT
      )
    ''');
  }

  // Hàm này sẽ chạy khi bạn tăng 'version' lên 2
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Logic an toàn để thêm cột nếu chúng chưa tồn tại
      // (Cách tốt nhất, thay vì xóa bảng)
      await db.execute("ALTER TABLE citizens ADD COLUMN sex TEXT");
      await db.execute("ALTER TABLE citizens ADD COLUMN dateOfExpiry TEXT");
      await db.execute("ALTER TABLE citizens ADD COLUMN personalIdentification TEXT");
      await db.execute("ALTER TABLE citizens ADD COLUMN dateOfIssue TEXT");
      await db.execute("ALTER TABLE citizens ADD COLUMN placeOfIssue TEXT");
    }
  }


  // Hàm để lưu thông tin (Không đổi)
  Future<void> insertCitizen(CitizenInfo citizen) async {
    final db = await database;
    await db.insert(
      'citizens',
      citizen.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Hàm để lấy tất cả thông tin (Đã sửa lỗi 'Null')
  Future<List<CitizenInfo>> getCitizens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('citizens');

    // Dùng factory 'fromMap' an toàn (sẽ không crash)
    return List.generate(maps.length, (i) {
      return CitizenInfo.fromMap(maps[i]);
    });
  }
}