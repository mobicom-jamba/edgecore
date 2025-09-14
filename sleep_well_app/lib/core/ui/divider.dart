import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });
  
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;
  
  @override
  Widget build(BuildContext context) => Divider(
    height: height,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
    color: color ?? AppTheme.divider,
  );
}
