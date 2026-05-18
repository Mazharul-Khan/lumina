import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/main.dart';

class QuickNoteScreen extends StatefulWidget {
  final VaultItem? item;

  const QuickNoteScreen({
    super.key,
    this.item,
  });

  @override
  State<QuickNoteScreen> createState() => _QuickNoteScreenState();
}

class _QuickNoteScreenState extends State<QuickNoteScreen> {
  final _titleController = TextEditingController();
  late final quill.QuillController _contentController;

  bool get _isEditMode => widget.item != null;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.item?.title ?? '';
    _contentController = _createController(widget.item?.contentText);
  }

  quill.QuillController _createController(String? rawContent) {
    if (rawContent == null || rawContent.trim().isEmpty) {
      return quill.QuillController.basic();
    }

    try {
      final decoded = jsonDecode(rawContent);
      final document = quill.Document.fromJson(
        List<dynamic>.from(decoded as List),
      );

      return quill.QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (_) {
      final document = quill.Document()..insert(0, rawContent);
      return quill.QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    final plainText = _contentController.document.toPlainText().trim();

    if (title.isEmpty || plainText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty")),
      );
      return;
    }

    final deltaJson = jsonEncode(
      _contentController.document.toDelta().toJson(),
    );

    final now = DateTime.now();

    final itemToSave = widget.item ??
        VaultItem(
          title: title,
          contentText: deltaJson,
          type: 'note',
          createdAt: now,
          updatedAt: now,
        );

    itemToSave
      ..title = title
      ..contentText = deltaJson
      ..type = widget.item?.type ?? 'note'
      ..updatedAt = now;

    objectBox.vaultBox.put(itemToSave);
    Navigator.pop(context, true);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = _isEditMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Note" : "Quick Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? "Update" : "Save"),
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