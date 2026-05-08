import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lumina/core/entity/vault_item.dart';

class AnimatedSlidableCard extends StatelessWidget {
  final VaultItem item;
  final VoidCallback onTap;
  const AnimatedSlidableCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final slideable = Slidable.of(context);
    final animation = slideable?.animation ?? const AlwaysStoppedAnimation(0.0);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        final paneType = slideable?.actionPaneType.value;

        // Is the panel fully open (or near to it after snap)?
        final isOpen = progress >= 0.25;

        // Default colors
        Color currentBgColor = Colors.white;
        Color currentTextColor = Colors.black87;
        Color shadowColor = Colors.black12;

        if (isOpen) {
          if (paneType == ActionPaneType.start) {
            // Right swipe / Delete fully open
            currentBgColor = const Color.fromARGB(255, 254, 6, 6);
            currentTextColor = Colors.white;
            shadowColor = Colors.red.withValues(alpha: 0.5);
          } else if (paneType == ActionPaneType.end) {
            // Left swipe / AI fully open
            currentBgColor = const Color(0xFF4A148C);
            currentTextColor = Colors.white;
            shadowColor = const Color(0xFF4A148C).withValues(alpha: 0.5);
          }
        }

        final currentElevation = 2.0 + (progress * 8.0);

        // We use AnimatedContainer and explicitly animate the style changes over 300ms
        // when the boolean state flips.
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: currentBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: currentElevation * 2,
                offset: Offset(0, currentElevation),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 1000),
                style: TextStyle(color: currentTextColor),
                child: ListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: currentTextColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    item.contentText ?? "No Content",
                    style: TextStyle(
                      color: currentTextColor.withValues(alpha: 0.8),
                    ),
                  ),
                  trailing: Text(
                    "${item.createdAt.year}-${item.createdAt.month.toString().padLeft(2, '0')}-${item.createdAt.day.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: currentTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
