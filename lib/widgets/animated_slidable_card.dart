import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lumina/core/entity/vault_item.dart';
import 'package:lumina/core/theme/app_theme.dart';

class AnimatedSlidableCard extends StatefulWidget {
  final VaultItem item;
  final VoidCallback onTap;
  const AnimatedSlidableCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<AnimatedSlidableCard> createState() => _AnimatedSlidableCardState();
}

class _AnimatedSlidableCardState extends State<AnimatedSlidableCard>
    with TickerProviderStateMixin {
  bool _wasOpen = false;
  bool _isHappticActive = false;

  late AnimationController _neonController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();

    _neonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _neonController.dispose();
    _sparkleController.dispose();
  }

  void _triggerHapticSequence() async {
    if (_isHappticActive) return;
    _isHappticActive = true;

    try {
      await HapticFeedback.heavyImpact();
      await HapticFeedback.heavyImpact();
      if (!mounted) return;
    } finally {
      if (mounted) {
        _isHappticActive = false;
      }
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case "note":
        return Icons.note;
      case "pdf":
        return Icons.picture_as_pdf;
      case "image":
        return Icons.image;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slideable = Slidable.of(context);
    final slidableAnim =
        slideable?.animation ?? const AlwaysStoppedAnimation(0.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([
        slidableAnim,
        _neonController,
        _sparkleController,
      ]),
      builder: (context, child) {
        final progress = slidableAnim.value;
        final paneType = slideable?.actionPaneType.value;
        final isOpen = progress >= 0.25;

        if (isOpen && !_wasOpen) {
          _wasOpen = true;
          _triggerHapticSequence();
        } else if (!isOpen && _wasOpen) {
          _wasOpen = false;
        }

        Color innerCardColor = isDark ? AppTheme.cardDark : AppTheme.cardLight;
        Color textColor =
            Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
        Color neonColor = isDark ? AppTheme.primaryDark : AppTheme.primaryLight;

        // Default colors
        // Color currentBgColor = Colors.white;
        // Color currentTextColor = Colors.black87;
        // Color shadowColor = Colors.black12;

        if (isOpen) {
          if (paneType == ActionPaneType.start) {
            innerCardColor = const Color.fromARGB(255, 220, 20, 20);
            textColor = Colors.white;
            neonColor = const Color.fromARGB(
              255,
              255,
              67,
              67,
            ); // turn off neon while deleting
          } else if (paneType == ActionPaneType.end) {
            innerCardColor = const Color(0xFF4A148C);
            textColor = Colors.white;
            neonColor = const Color.fromARGB(
              255,
              118,
              0,
              245,
            ); // turn off neon for AI
          }
        }

        final currentElevation = 2.0 + (progress * 8.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: neonColor.withValues(alpha: 0.3),
                  blurRadius: 10 + currentElevation,
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                ),
              ],
              gradient: SweepGradient(
                colors: [
                  Colors.transparent,
                  neonColor.withValues(alpha: 0.8),
                  Colors.transparent,
                  neonColor.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                transform: GradientRotation(
                  _neonController.value * 2 * 3.14159,
                ),
              ),
            ),
            padding: const EdgeInsets.all(
              2,
            ), // Outer padding for the neon border

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: innerCardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: widget.onTap,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.item.title,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    widget.item.contentText ??
                                        "No Content available",
                                    style: TextStyle(
                                      color: textColor.withValues(alpha: 0.7),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "${widget.item.createdAt.year}-${widget.item.createdAt.month.toString().padLeft(2, '0')}-${widget.item.createdAt.day.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      color: textColor.withValues(alpha: 0.4),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: textColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getTypeIcon(widget.item.type),
                                    color: textColor.withValues(alpha: 0.9),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: ScaleTransition(
                          scale: Tween(begin: 0.6, end: 1.1).animate(
                            CurvedAnimation(
                              parent: _sparkleController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: isOpen
                                ? Colors.white30
                                : neonColor.withValues(alpha: 0.5),
                            size: 16,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: ScaleTransition(
                          scale: Tween(begin: 1.1, end: 0.6).animate(
                            CurvedAnimation(
                              parent: _sparkleController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            color: isOpen
                                ? Colors.white30
                                : neonColor.withValues(alpha: 0.5),
                            size: 12,
                          ),
                        ),
                      ),
                    ],
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
