import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/main.dart';
import 'package:lumina/screens/quick_note_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final VaultItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late VaultItem _item;
  late quill.QuillController _contentController;

  @override
  void initState() {
    super.initState();
    _item = objectBox.vaultBox.get(widget.item.id) ?? widget.item;
    _contentController = _createController(_item.contentText);
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

  void _reloadLatestItem() {
    final latest = objectBox.vaultBox.get(widget.item.id);
    if (latest != null) {
      _item = latest;
      _contentController.dispose();
      _contentController = _createController(_item.contentText);
    }
  }

  Future<void> _openEditor() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => QuickNoteScreen(item: _item),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _reloadLatestItem();
      });
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _openEditor,
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => _showSnack("AI Summary coming soon"),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble),
            onPressed: () => _showSnack("AI Chat coming soon"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _item.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text("Type: ${_item.type}", style: bodyStyle),
            const SizedBox(height: 8),
            Text(
              "Updated: ${_item.updatedAt}",
              style: bodyStyle?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                  ),
                ),
                child: IgnorePointer(
                  child: quill.QuillEditor.basic(
                    controller: _contentController,
                    config: const quill.QuillEditorConfig(
                      expands: true,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}