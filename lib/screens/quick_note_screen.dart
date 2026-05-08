import 'package:flutter/material.dart';
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/main.dart';

class QuickNoteScreen extends StatefulWidget {
  const QuickNoteScreen({super.key});

  @override
  State<QuickNoteScreen> createState() => _QuickNoteScreenState();
}

class _QuickNoteScreenState extends State<QuickNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and content cannot be empty")),
      );
      return;
    }
    final item = VaultItem(
      title: title,
      contentText: content,
      type: 'note',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    objectBox.vaultBox.put(item);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Note"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter Title",
                labelText: "Title",
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Enter Content",
                  labelText: "Content",
                ),
                maxLines: null,
                minLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
