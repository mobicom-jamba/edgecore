import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
  });
  
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  
  @override
  Widget build(BuildContext context) => AppBar(
    title: Text(
      title,
      style: AppTheme.title,
    ),
    leading: leading,
    actions: actions,
    centerTitle: centerTitle,
    elevation: elevation,
    backgroundColor: AppTheme.background,
    foregroundColor: AppTheme.textPrimary,
    titleTextStyle: AppTheme.title,
  );
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
