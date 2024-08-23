// ignore_for_file: unused_local_variable

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/enum/persistence_enum.dart';
import '../../interfaces/persistence_interface.dart';

class PersistenceRepository implements IPersistence {
  static const _storage = FlutterSecureStorage();

  static String _getKeyString(SecureKey key) {
    switch (key) {
      case SecureKey.token:
        return 'token';
      default:
        throw Exception();
    }
  }

  @override
  Future<void> delete({required SecureKey key}) async{
    try {
      await _storage.delete(key: _getKeyString(key));
    } catch (e) {
      Exception(e);
    }
  }

  @override
  Future<void> deleteAll({required SecureKey key}) async{
    try {
      await _storage.deleteAll();
    } catch (e) {
      Exception(e);
    }
  }

  @override
  Future<String?> read({required SecureKey key}) async{
    try {
      return await _storage.read(key: _getKeyString(key));
    } catch (e) {
      Exception(e);

      return null;
    }
  }

  @override
  Future<void> update({required SecureKey key, required String value}) async{
    try {
      await _storage.write(key: _getKeyString(key), value: value);
    } catch (e) {
      Exception(e);
    }
  }
}