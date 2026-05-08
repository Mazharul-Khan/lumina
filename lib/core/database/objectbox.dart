import 'package:lumina/core/entity/chat_message.dart';
import 'package:lumina/core/entity/summary.dart';
import 'package:lumina/core/entity/tag.dart';
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox{
  late final Store store;

   late final Box<VaultItem> vaultBox;
   late final Box<Summary> summaryBox;
   late final Box<Chatmessage> chatBox;
   late final Box<Tag> tagBox;


   ObjectBox._create(this.store){
    vaultBox = Box<VaultItem>(store);
    summaryBox = Box<Summary>(store);
    chatBox = Box<Chatmessage>(store);
    tagBox = Box<Tag>(store);
   }

   static Future<ObjectBox> create() async{
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory : '${dir.path}/objectbox');
    return ObjectBox._create(store);
   }

   
}