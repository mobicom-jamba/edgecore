import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.message,
  });
  
  final String? message;
  
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spacing16),
            Text(
              message!,
              style: AppTheme.body,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    ),
  );
}
