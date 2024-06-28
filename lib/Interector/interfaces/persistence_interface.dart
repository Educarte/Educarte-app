import '../enum/persistence_enum.dart';

abstract class IPersistence {
  Future<void> update({required SecureKey key, required String value});

  Future<String?> read({required SecureKey key});

  Future<void> delete({required SecureKey key});

  Future<void> deleteAll({required SecureKey key});
}