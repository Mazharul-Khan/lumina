import 'package:objectbox/objectbox.dart';

@Entity()
class Tag{

  int id =0;
  String name;
  Tag({
    required this.name,
  });
}