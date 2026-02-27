import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../theme/app_theme.dart';

enum _ButtonVariant { primary, ghost, danger, icon }

class AppButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final _ButtonVariant _variant;

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
  }) : icon = null,
       _variant = _ButtonVariant.primary;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
  }) : icon = null,
       _variant = _ButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
  }) : icon = null,
       _variant = _ButtonVariant.danger;

  const AppButton.icon({super.key, required this.icon, required this.onPressed})
    : label = null,
      _variant = _ButtonVariant.icon;

  @override
  Widget build(BuildContext context) {
    if (_variant == _ButtonVariant.icon) {
      return IconButton(
        icon: Icon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? side;

    switch (_variant) {
      case _ButtonVariant.primary:
        backgroundColor = AppColors.accentBlue;
        foregroundColor = AppColors.textInverse;
        side = null;
        break;
      case _ButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.accentBlue;
        side = const BorderSide(color: AppColors.accentBlue);
        break;
      case _ButtonVariant.danger:
        backgroundColor = AppColors.accentRed;
        foregroundColor = AppColors.textPrimary;
        side = null;
        break;
      case _ButtonVariant.icon:
        // Handled above
        throw Exception('Unreachable');
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        minimumSize: const Size(0, 48), // Minimum 48px height per UI Guide
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: side ?? BorderSide.none,
        ),
      ),
      child: Text(
        label!,
        style: AppTextStyles.label.copyWith(color: foregroundColor),
      ),
    );
  }
}
