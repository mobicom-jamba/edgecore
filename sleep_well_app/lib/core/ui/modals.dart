import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class Toast extends StatelessWidget {
  
  const Toast({
    super.key,
    required this.message,
    required this.type,
    this.onAction,
    this.actionText,
  });
  final String message;
  final ToastType type;
  final VoidCallback? onAction;
  final String? actionText;
  
  @override
  Widget build(BuildContext context) {
    final colors = _getColors(type);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        boxShadow: AppTheme.shadowMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            colors.icon,
            color: colors.foreground,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Flexible(
            child: Text(
              message,
              style: AppTheme.body.copyWith(color: colors.foreground),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  _ToastColors _getColors(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastColors(
          background: AppTheme.success,
          foreground: AppTheme.background,
          icon: Icons.check_circle_outline,
        );
      case ToastType.warning:
        return _ToastColors(
          background: AppTheme.warning,
          foreground: AppTheme.background,
          icon: Icons.warning_outlined,
        );
      case ToastType.info:
        return _ToastColors(
          background: AppTheme.info,
          foreground: AppTheme.background,
          icon: Icons.info_outline,
        );
      case ToastType.error:
        return _ToastColors(
          background: AppTheme.error,
          foreground: AppTheme.background,
          icon: Icons.error_outline,
        );
    }
  }
  
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticFeedback.lightImpact();
    
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacing16,
        left: AppTheme.spacing16,
        right: AppTheme.spacing16,
        child: Toast(
          message: message,
          type: type,
          onAction: onAction,
          actionText: actionText,
        ),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

enum ToastType { success, warning, info, error }

class _ToastColors {
  
  const _ToastColors({
    required this.background,
    required this.foreground,
    required this.icon,
  });
  final Color background;
  final Color foreground;
  final IconData icon;
}
