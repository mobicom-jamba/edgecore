import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomSheetModal extends StatelessWidget {
  const BottomSheetModal({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.isDismissible = true,
    this.maxHeight,
  });
  
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final bool isDismissible;
  final double? maxHeight;
  
  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(
      maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
    ),
    decoration: const BoxDecoration(
      color: AppTheme.surface,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radiusCard),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: AppTheme.spacing12),
          decoration: BoxDecoration(
            color: AppTheme.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
          child: Text(
            title,
            style: AppTheme.title,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        // Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            child: content,
          ),
        ),
        // Actions
        if (actions != null) ...[
          const SizedBox(height: AppTheme.spacing16),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: actions!
                  .map((action) => Expanded(child: action))
                  .expand((widget) => [widget, const SizedBox(width: AppTheme.spacing8)])
                  .take(actions!.length * 2 - 1)
                  .toList(),
            ),
          ),
        ],
        // Safe area bottom padding
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    ),
  );
  
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool isDismissible = true,
    double? maxHeight,
  }) => showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BottomSheetModal(
      title: title,
      content: content,
      actions: actions,
      isDismissible: isDismissible,
      maxHeight: maxHeight,
    ),
  );
}
