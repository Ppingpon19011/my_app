import 'dart:async';
import 'package:my_app/database/database_helper.dart';
import 'package:my_app/user_repository.dart';

class CattleRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // เพิ่มโปรไฟล์โค
  Future<int> addCattleProfile(Map<String, dynamic> profileData, String userId) async {
    // เพิ่ม user_id เข้าไปในข้อมูลโค
    profileData['user_id'] = userId;
    return await _databaseHelper.insertCattleProfile(profileData);
  }

  // ดึงโปรไฟล์โคทั้งหมด
  Future<List<Map<String, dynamic>>> getAllCattleProfiles() async {
    return await _databaseHelper.getAllCattleProfiles();
  }

  // ดึงโปรไฟล์โคของผู้ใช้ที่ล็อกอินอยู่
  Future<List<Map<String, dynamic>>> getCurrentUserCattleProfiles(String userId) async {
    return await _databaseHelper.getCattleProfilesByUserId(userId);
  }

  // ดึงโปรไฟล์โคตาม ID
  Future<Map<String, dynamic>?> getCattleProfileById(int id) async {
    return await _databaseHelper.getCattleProfileById(id);
  }

  // ค้นหาโปรไฟล์โค
  Future<List<Map<String, dynamic>>> searchCattleProfiles(String query) async {
    return await _databaseHelper.searchCattleProfiles(query);
  }

  // ค้นหาโปรไฟล์โคตามผู้ใช้
  Future<List<Map<String, dynamic>>> searchCattleProfilesByUser(String query, String userId) async {
    List<Map<String, dynamic>> results = await _databaseHelper.searchCattleProfiles(query);
    return results.where((profile) => profile['user_id'] == userId).toList();
  }

  // อัปเดตโปรไฟล์โค
  Future<int> updateCattleProfile(Map<String, dynamic> profileData) async {
    return await _databaseHelper.updateCattleProfile(profileData);
  }

  // ลบโปรไฟล์โค
  Future<int> deleteCattleProfile(int id) async {
    return await _databaseHelper.deleteCattleProfile(id);
  }

  // จัดการข้อมูลผู้ใช้
  Future<int> saveUserData(MyUser user) async {
    return await _databaseHelper.insertUser(user);
  }

  Future<MyUser?> getUserData(String userId) async {
    return await _databaseHelper.getUser(userId);
  }

  Future<int> updateUserLastLogin(String userId) async {
    return await _databaseHelper.updateLastLogin(userId);
  }

  Future<int> deleteUserData(String userId) async {
    return await _databaseHelper.deleteUser(userId);
  }
}