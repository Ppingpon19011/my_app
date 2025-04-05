import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_app/user_repository.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // ชื่อตารางโค
  final String tableCattle = 'cattle_profile';
  
  // คอลัมน์ในตารางโค
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnNumber = 'number';
  final String columnGender = 'gender';
  final String columnBirthdate = 'birthdate';
  final String columnBreed = 'breed';
  final String columnColor = 'color';
  final String columnFatherNumber = 'father_number';
  final String columnMotherNumber = 'mother_number';
  final String columnBreeder = 'breeder';
  final String columnOwner = 'owner';
  final String columnWeight = 'weight';
  final String columnImagePath = 'image_path';

  // ตารางผู้ใช้และคอลัมน์ที่เกี่ยวข้อง
  final String tableUser = 'user';
  final String columnUserId = 'id';
  final String columnUserEmail = 'email';
  final String columnUserName = 'name';
  final String columnUserLastLogin = 'last_login';
  final String columnUserPhotoUrl = 'photo_url';

  // Singleton pattern
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // สร้างและเปิดฐานข้อมูล
  _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'cattle_app.db');
    
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  // สร้างตารางในฐานข้อมูล
  Future _onCreate(Database db, int version) async {
    // สร้างตารางโค
    await db.execute('''
      CREATE TABLE $tableCattle (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnNumber TEXT,
        $columnGender TEXT,
        $columnBirthdate TEXT,
        $columnBreed TEXT,
        $columnColor TEXT,
        $columnFatherNumber TEXT,
        $columnMotherNumber TEXT,
        $columnBreeder TEXT,
        $columnOwner TEXT,
        $columnWeight TEXT,
        $columnImagePath TEXT,
        $columnUserId TEXT
      )
    ''');
    
    // สร้างตารางผู้ใช้
    await db.execute('''
      CREATE TABLE $tableUser (
        $columnUserId TEXT PRIMARY KEY,
        $columnUserEmail TEXT,
        $columnUserName TEXT,
        $columnUserLastLogin TEXT,
        $columnUserPhotoUrl TEXT
      )
    ''');
  }

  // แปลงข้อมูลจากรูปแบบที่ใช้ในแอปเป็นรูปแบบที่ใช้ใน SQLite
  Map<String, dynamic> _transformToDb(Map<String, dynamic> profileData) {
    return {
      columnName: profileData['ชื่อโค'],
      columnNumber: profileData['หมายเลขโค'],
      columnGender: profileData['เพศ'],
      columnBirthdate: profileData['วัน/เดือน/ปีเกิด'],
      columnBreed: profileData['สายพันธุ์'],
      columnColor: profileData['สีตัวโค'],
      columnFatherNumber: profileData['หมายเลขพ่อพันธุ์'],
      columnMotherNumber: profileData['หมายเลขแม่พันธุ์'],
      columnBreeder: profileData['ชื่อผู้เลี้ยง'],
      columnOwner: profileData['ชื่อเจ้าของในปัจจุบัน'],
      columnWeight: profileData['น้ำหนัก'],
      columnImagePath: profileData['รูปภาพ'],
      columnUserId: profileData['user_id'],
    };
  }

  // แปลงข้อมูลจากรูปแบบที่ใช้ใน SQLite เป็นรูปแบบที่ใช้ในแอป
  Map<String, dynamic> _transformFromDb(Map<String, dynamic> dbData) {
    return {
      'id': dbData[columnId],
      'ชื่อโค': dbData[columnName],
      'หมายเลขโค': dbData[columnNumber],
      'เพศ': dbData[columnGender],
      'วัน/เดือน/ปีเกิด': dbData[columnBirthdate],
      'สายพันธุ์': dbData[columnBreed],
      'สีตัวโค': dbData[columnColor],
      'หมายเลขพ่อพันธุ์': dbData[columnFatherNumber],
      'หมายเลขแม่พันธุ์': dbData[columnMotherNumber],
      'ชื่อผู้เลี้ยง': dbData[columnBreeder],
      'ชื่อเจ้าของในปัจจุบัน': dbData[columnOwner],
      'น้ำหนัก': dbData[columnWeight],
      'รูปภาพ': dbData[columnImagePath],
      'user_id': dbData[columnUserId],
    };
  }

  // CRUD Operations สำหรับโค:

  // เพิ่มโปรไฟล์โค
  Future<int> insertCattleProfile(Map<String, dynamic> profileData) async {
    Database db = await database;
    var dbData = _transformToDb(profileData);
    return await db.insert(tableCattle, dbData);
  }

  // ดึงโปรไฟล์โคทั้งหมด
  Future<List<Map<String, dynamic>>> getAllCattleProfiles() async {
    Database db = await database;
    var result = await db.query(tableCattle);
    return result.map((item) => _transformFromDb(item)).toList();
  }

  // ดึงโปรไฟล์โคตาม ID
  Future<Map<String, dynamic>?> getCattleProfileById(int id) async {
    Database db = await database;
    var result = await db.query(
      tableCattle,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return _transformFromDb(result.first);
    }
    return null;
  }

  // ค้นหาโปรไฟล์โคด้วยชื่อหรือหมายเลข
  Future<List<Map<String, dynamic>>> searchCattleProfiles(String query) async {
    Database db = await database;
    var result = await db.query(
      tableCattle,
      where: '$columnName LIKE ? OR $columnNumber LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    
    return result.map((item) => _transformFromDb(item)).toList();
  }

  // อัปเดตโปรไฟล์โค
  Future<int> updateCattleProfile(Map<String, dynamic> profileData) async {
    Database db = await database;
    var dbData = _transformToDb(profileData);
    return await db.update(
      tableCattle,
      dbData,
      where: '$columnId = ?',
      whereArgs: [profileData['id']],
    );
  }

  // ลบโปรไฟล์โค
  Future<int> deleteCattleProfile(int id) async {
    Database db = await database;
    return await db.delete(
      tableCattle,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // ดึงรายการโคตาม user ID
  Future<List<Map<String, dynamic>>> getCattleProfilesByUserId(String userId) async {
    Database db = await database;
    
    var result = await db.query(
      tableCattle,
      where: '$columnUserId = ?',
      whereArgs: [userId]
    );
    
    return result.map((item) => _transformFromDb(item)).toList();
  }

  // CRUD Operations สำหรับผู้ใช้:

  // เพิ่มผู้ใช้ใหม่หรืออัปเดตข้อมูลผู้ใช้ที่มีอยู่แล้ว
  Future<int> insertUser(MyUser user) async {
    Database db = await database;
    
    Map<String, dynamic> userMap = {
      columnUserId: user.id,
      columnUserEmail: user.email,
      columnUserName: user.name,
      columnUserLastLogin: DateTime.now().toIso8601String(),
      columnUserPhotoUrl: user.photoUrl
    };
    
    // ตรวจสอบว่ามีผู้ใช้นี้อยู่แล้วหรือไม่
    List<Map<String, dynamic>> existingUser = await db.query(
      tableUser, 
      where: '$columnUserId = ?', 
      whereArgs: [user.id]
    );
    
    if (existingUser.isNotEmpty) {
      // อัปเดตผู้ใช้ที่มีอยู่
      return await db.update(
        tableUser, 
        userMap, 
        where: '$columnUserId = ?', 
        whereArgs: [user.id]
      );
    } else {
      // เพิ่มผู้ใช้ใหม่
      return await db.insert(tableUser, userMap);
    }
  }

  // ดึงข้อมูลผู้ใช้ตาม ID
  Future<MyUser?> getUser(String id) async {
    Database db = await database;
    
    List<Map<String, dynamic>> result = await db.query(
      tableUser, 
      where: '$columnUserId = ?', 
      whereArgs: [id]
    );
    
    if (result.isNotEmpty) {
      // แปลงจาก Map เป็นออบเจ็กต์ MyUser
      return MyUser(
        id: result[0][columnUserId],
        email: result[0][columnUserEmail],
        name: result[0][columnUserName],
        photoUrl: result[0][columnUserPhotoUrl],
      );
    }
    return null;
  }

  // อัปเดตข้อมูลการล็อกอินล่าสุด
  Future<int> updateLastLogin(String userId) async {
    Database db = await database;
    
    return await db.update(
      tableUser,
      {columnUserLastLogin: DateTime.now().toIso8601String()},
      where: '$columnUserId = ?',
      whereArgs: [userId]
    );
  }

  // ลบข้อมูลผู้ใช้
  Future<int> deleteUser(String id) async {
    Database db = await database;
    
    // ลบโคทั้งหมดที่เป็นของผู้ใช้นี้
    await db.delete(
      tableCattle,
      where: '$columnUserId = ?',
      whereArgs: [id]
    );
    
    // ลบข้อมูลผู้ใช้
    return await db.delete(
      tableUser,
      where: '$columnUserId = ?',
      whereArgs: [id]
    );
  }
}