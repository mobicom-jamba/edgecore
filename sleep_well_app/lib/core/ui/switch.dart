import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.materialTapTargetSize = MaterialTapTargetSize.padded,
  });
  
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final MaterialTapTargetSize materialTapTargetSize;
  
  @override
  Widget build(BuildContext context) => Switch(
    value: value,
    onChanged: (newValue) {
      HapticFeedback.selectionClick();
      onChanged(newValue);
    },
    activeColor: activeColor ?? AppTheme.accentPrimary,
    inactiveThumbColor: inactiveThumbColor ?? AppTheme.textSecondary,
    activeTrackColor: activeTrackColor ?? AppTheme.accentPrimary.withOpacity(0.3),
    inactiveTrackColor: inactiveTrackColor ?? AppTheme.divider,
    materialTapTargetSize: materialTapTargetSize,
  );
}
