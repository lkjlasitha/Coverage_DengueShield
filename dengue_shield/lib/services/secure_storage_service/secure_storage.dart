import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _keyStorageKey = 'encryption_key';

  /// Generate a new encryption key and store it securely
  Future<String> _generateAndStoreKey() async {
    final key = encrypt.Key.fromSecureRandom(32); // 32-byte key for AES-256
    final keyBase64 = base64Encode(key.bytes);
    await _secureStorage.write(key: _keyStorageKey, value: keyBase64);
    return keyBase64;
  }

  /// Retrieve or generate the encryption key
  Future<encrypt.Key> _getEncryptionKey() async {
    String? keyBase64 = await _secureStorage.read(key: _keyStorageKey);
    keyBase64 ??= await _generateAndStoreKey();
    return encrypt.Key(base64Decode(keyBase64));
  }

  /// Generate secure random bytes using Random.secure()
  Uint8List _generateSecureRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  /// Encrypt and save sensitive data using AES-GCM in Flutter Secure Storage
  // Future<void> saveSecureData(String key, String value) async {
  //   try {
  //     final encryptionKey = await _getEncryptionKey();
  //     final encrypter = encrypt.Encrypter(encrypt.AES(
  //       encryptionKey,
  //       mode: encrypt.AESMode.gcm, // Use AES-GCM
  //     ));

  //     // Generate a 12-byte secure random IV
  //     final iv = encrypt.IV(_generateSecureRandomBytes(12));

  //     // Encrypt the data
  //     final encrypted = encrypter.encrypt(value, iv: iv);

  //     // Store both IV and encrypted data
  //     final encryptedData = jsonEncode({
  //       'iv': base64Encode(iv.bytes), // Encode IV as base64
  //       'data': encrypted.base64, // Encrypted data as base64
  //     });

  //     await _secureStorage.write(key: key, value: encryptedData);
  //   } catch (e) {
  //     throw Exception('Failed to save secure data: $e');
  //   }
  // }

  /// Decrypt and read sensitive data using AES-GCM from Flutter Secure Storage
  // Future<String?> readSecureData(String key) async {
  //   try {
  //     final encryptedData = await _secureStorage.read(key: key);
  //     if (encryptedData == null) return null;

  //     final encryptionKey = await _getEncryptionKey();
  //     final encrypter = encrypt.Encrypter(encrypt.AES(
  //       encryptionKey,
  //       mode: encrypt.AESMode.gcm, // Use AES-GCM
  //     ));

  //     final Map<String, dynamic> jsonData = jsonDecode(encryptedData);
  //     final iv = encrypt.IV(base64Decode(jsonData['iv']));
  //     final data = jsonData['data'];

  //     // Decrypt the data
  //     final decrypted = encrypter.decrypt64(data, iv: iv);
  //     return decrypted;
  //   } catch (e) {
  //     throw Exception('Failed to read secure data: $e');
  //   }
  // }

  /// Clear all secure data from Flutter Secure Storage
  Future<void> clearAllData() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear secure data: $e');
    }
  }

  /// Save encrypted data to app-specific storage
  Future<void> saveSecureData(String fileName, String value) async {
    try {
      final encryptionKey = await _getEncryptionKey();
      final encrypter = encrypt.Encrypter(encrypt.AES(
        encryptionKey,
        mode: encrypt.AESMode.gcm, // Use AES-GCM
      ));

      // Generate a 12-byte secure random IV
      final iv = encrypt.IV(_generateSecureRandomBytes(12));

      // Encrypt the data
      final encrypted = encrypter.encrypt(value, iv: iv);

      // Prepare the encrypted data object
      final encryptedData = jsonEncode({
        'iv': base64Encode(iv.bytes),
        'data': encrypted.base64,
      });

      // Save the encrypted data to app-specific directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsString(encryptedData);

      print('Data saved to: $filePath');
    } catch (e) {
      throw Exception('Failed to save data to app-specific directory: $e');
    }
  }

  /// Read encrypted data from app-specific storage and decrypt it
  Future<String?> readSecureData(String fileName) async {
    try {
      // Get the app-specific directory path
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Check if the file exists
      if (!await file.exists()) {
        print('File not found: $filePath');
        return null;
      }

      // Read the encrypted data from file
      final encryptedData = await file.readAsString();

      // Parse the JSON to retrieve IV and encrypted text
      final Map<String, dynamic> jsonData = jsonDecode(encryptedData);
      final iv = encrypt.IV(base64Decode(jsonData['iv']));
      final encryptedText = jsonData['data'];

      // Decrypt the data
      final encryptionKey = await _getEncryptionKey();
      final encrypter = encrypt.Encrypter(encrypt.AES(
        encryptionKey,
        mode: encrypt.AESMode.gcm,
      ));
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

      return decrypted;
    } catch (e) {
      print('Failed to read data from app-specific directory: $e');
      return null;
      //throw Exception('Failed to read data from app-specific directory: $e');
      //MessageUtils.showApiErrorMessage(context, 'Failed to read data from app-specific directory: $e')
    }
  }
}
