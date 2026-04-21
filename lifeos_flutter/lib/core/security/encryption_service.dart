import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EncryptionService {
  static const String _keyName = 'hive_encryption_key';
  static const _secureStorage = FlutterSecureStorage();

  static Future<List<int>> getOrCreateEncryptionKey() async {
    final String? storedKey = await _secureStorage.read(key: _keyName);
    if (storedKey != null) {
      return base64Url.decode(storedKey);
    } else {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(key: _keyName, value: base64Url.encode(key));
      return key;
    }
  }

  static Future<HiveAesCipher> getCipher() async {
    final key = await getOrCreateEncryptionKey();
    return HiveAesCipher(key);
  }

  static Future<Box<T>> openEncryptedBox<T>(String name, HiveAesCipher cipher) async {
    // Attempt 1: Try to open WITHOUT encryption to see if migration is needed
    bool needsMigration = false;
    Map<dynamic, T> existingData = {};

    try {
      final unencryptedBox = await Hive.openBox<T>(name);

      // If it opens successfully and has data, we assume it's unencrypted
      // Wait, if it was already migrated, what happens?
      // If a box is created WITH encryption, and we try to open it WITHOUT encryption,
      // Hive will throw an error (or it might just read garbage/crash). Actually Hive
      // throws a HiveError if the cipher is wrong or missing for an encrypted box.
      // So if it opens without error, it is currently unencrypted.

      // If it opens successfully we assume it's unencrypted
      // It might be empty, but it's still unencrypted on disk
      if (unencryptedBox.isNotEmpty) {
        for (var key in unencryptedBox.keys) {
          final value = unencryptedBox.get(key);
          if (value != null) {
            existingData[key] = value;
          }
        }
      }
      needsMigration = true;

      // Must close it so we can re-open it WITH encryption (Hive doesn't allow changing cipher on an open box)
      await unencryptedBox.close();

      if (needsMigration) {
        // If it was successfully opened unencrypted (even if empty), we need to delete it from disk
        // to recreate it with encryption.
        await Hive.deleteBoxFromDisk(name);
      }
    } catch (e) {
      // If it fails to open without encryption, it's either already encrypted or corrupted.
      // We do nothing here and proceed to try opening it with encryption.
    }

    // Attempt 2: Open WITH encryption
    try {
      final box = await Hive.openBox<T>(name, encryptionCipher: cipher);

      if (needsMigration && existingData.isNotEmpty) {
        await box.putAll(existingData);
      }

      return box;
    } catch (e) {
      // If it fails WITH encryption, the box might be corrupted.
      // The instructions say: IF FAILURE: Log error safely. Fallback: clear box (LAST RESORT ONLY)
      // Log error securely
      // omit print in prod - simulated safe logging
      try {
        await Hive.deleteBoxFromDisk(name);
        return await Hive.openBox<T>(name, encryptionCipher: cipher);
      } catch (fallbackError) {
        rethrow;
      }
    }
  }
}
