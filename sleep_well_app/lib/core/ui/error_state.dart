import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    required this.description,
    this.action,
    this.actionText,
  });
  
  final String title;
  final String description;
  final VoidCallback? action;
  final String? actionText;
  
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppTheme.error,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            title,
            style: AppTheme.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            description,
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          if (action != null && actionText != null) ...[
            const SizedBox(height: AppTheme.spacing32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: action,
                child: Text(actionText!),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
