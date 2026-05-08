import 'package:flutter/material.dart';
import 'package:lumina/core/entity/vault_item.dart';

class ItemDetailsScreen extends StatelessWidget {
  final VaultItem item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text("Type:  ${item.type}"),
            SizedBox(height: 8),
            Text(
              item.contentText ?? "No Content",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
