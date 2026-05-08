import 'package:lumina/core/entity/vault_item.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Chatmessage {

  int id = 0;

  final item = ToOne<VaultItem>();
  String role;
  String message;

  DateTime createdAt;

  Chatmessage({
    required this.role,
    required this.message,
    required this.createdAt,
  });


}