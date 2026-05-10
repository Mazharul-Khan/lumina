import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/main.dart';

class QuickNoteScreen extends StatefulWidget {
  const QuickNoteScreen({super.key});

  @override
  State<QuickNoteScreen> createState() => _QuickNoteScreenState();
}

class _QuickNoteScreenState extends State<QuickNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = quill.QuillController.basic();

  void _save() {
    final title = _titleController.text.trim();
    final deltaJson = jsonEncode(
      _contentController.document.toDelta().toJson(),
    );

    if (title.isEmpty || _contentController.document.toPlainText().trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and content cannot be empty")),
      );
      return;
    }
    final item = VaultItem(
      title: title,
      contentText: deltaJson,
      type: 'note',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    objectBox.vaultBox.put(item);
    Navigator.pop(context, true);
  }
  @override
void dispose() {
  _titleController.dispose();
  _contentController.dispose();
  super.dispose();
}

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quick Note"),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Enter Title",
                labelText: "Title",
                border: UnderlineInputBorder(),
              ),
            ),
          ),

          quill.QuillSimpleToolbar(
            controller: _contentController,
            config: quill.QuillSimpleToolbarConfig(
              showAlignmentButtons: true,
              showColorButton: true,
              showBackgroundColorButton: true,
              showInlineCode: true,
              showUndo: true,
              showRedo: true,
              showFontSize: true,
              showFontFamily: true,
              showItalicButton: true,
              showBoldButton: true,
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: quill.QuillEditor.basic(
                controller: _contentController,
                config: quill.QuillEditorConfig(
                  expands: true,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: Text("Save"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showSnack("AI Summary coming soon"),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text("AI Summary"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showSnack("AI Chat coming soon"),
                    icon: const Icon(Icons.chat_bubble),
                    label: const Text("AI Chat"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
