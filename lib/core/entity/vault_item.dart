import 'package:objectbox/objectbox.dart';

@Entity()
class VaultItem {
  int id =0;

  String title;
  String type;
  
  String? contentText;
  String? filePath;

  DateTime createdAt;
  DateTime updatedAt;

  bool isFavorite;

  VaultItem({
    required this.title,
    required this.type,
    this.contentText,
    this.filePath,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });
}