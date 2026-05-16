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

    if (title.isEmpty ||
        _contentController.document.toPlainText().trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty")),
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
        title: const Text("Quick Note"),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      // This is the default, but explicitly ensures the column resizes when keyboard opens
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // 1. Title Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Enter Title",
                labelText: "Title",
                border: UnderlineInputBorder(),
              ),
            ),
          ),

          // 2. The Text Editor (Takes up all available remaining middle space)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: quill.QuillEditor.basic(
                controller: _contentController,
                config: const quill.QuillEditorConfig(
                  expands: true,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // 3. Save & AI Buttons (Sits directly above the toolbar, never hidden!)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                ),
                const SizedBox(width: 12),
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

          const Divider(height: 1, thickness: 0.5),

          // 4. Grouped Single-Row Toolbar sitting naturally at the absolute bottom of the column
          SafeArea(
            top: false,
            child: SizedBox(
              height: 54,
              child: quill.QuillSimpleToolbar(
                controller: _contentController,
                config: const quill.QuillSimpleToolbarConfig(
                  multiRowsDisplay: false,
                  toolbarSize: 40,

                  showFontSize: true,
                  showFontFamily: true,
                  showAlignmentButtons: true,
                  showColorButton: true,
                  showBackgroundColorButton: true,
                  showInlineCode: true,
                  showUndo: true,
                  showRedo: true,
                  showItalicButton: true,
                  showBoldButton: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
