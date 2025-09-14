import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CardSection extends StatelessWidget {
  const CardSection({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.padding,
  });
  
  final String title;
  final Widget body;
  final Widget? action;
  final EdgeInsets? padding;
  
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.title,
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          body,
        ],
      ),
    ),
  );
}
