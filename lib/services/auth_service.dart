import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    print('Storage directory: ${directory?.path}');
    return directory?.path ?? (await getApplicationDocumentsDirectory()).path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/users.txt');
    print('File path: ${file.path}');
    return file;
  }

  String _hashPassword(String password) {   
    return base64.encode(utf8.encode(password));
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];

      final contents = await file.readAsLines();
      return contents.map((line) => json.decode(line) as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error reading users: $e');
      return [];
      
    }
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      // Debug print before getting file path
      print('\n=== Starting User Registration ===');
      
      final directory = await getExternalStorageDirectory();
      print('Storage Directory: ${directory?.path}');
      
      final file = File('${directory?.path}/users.txt');
      print('File Location: ${file.path}');

      // Debug print user data
      print('\nSaving User Data:');
      print('Name: ${userData['prenom']} ${userData['nom']}');
      print('Email: ${userData['email']}');

      // Hash password and save
      userData['password'] = _hashPassword(userData['password']);
      final userString = json.encode(userData);
      
      await file.writeAsString('$userString\n', mode: FileMode.append);
      print('\nUser saved successfully! ✅');
      
      // Read and display current users
      final contents = await file.readAsString();
      print('\nCurrent File Contents:');
      print(contents);
      print('\n===========================');
    } catch (e) {
      print('\n❌ Error saving user: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return false;

      final contents = await file.readAsLines();
      return contents.any((line) {
        final userData = json.decode(line) as Map<String, dynamic>;
        return userData['email'] == email;
      });
    } catch (e) {
      return false;
    }
  }
}
