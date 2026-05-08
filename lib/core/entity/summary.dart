import 'package:lumina/core/entity/vault_item.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Summary{

  int id = 0;

  final item = ToOne<VaultItem>();

  String shortSummary;
  String keyWords;

  DateTime generatedAt;

  Summary({
    required this.shortSummary,
    required this.keyWords,
    required this.generatedAt,
  });
}