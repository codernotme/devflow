import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../features/projects/models/priority.dart';

class PriorityBadge extends StatelessWidget {
  final Priority priority;

  const PriorityBadge({super.key, required this.priority});

  Color get _color {
    switch (priority) {
      case Priority.critical:
        return AppColors.accentRed;
      case Priority.high:
        return AppColors.accentAmber;
      case Priority.medium:
        return AppColors.accentBlue;
      case Priority.low:
        return AppColors.textMuted;
    }
  }

  String get _label => priority.name.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(_label, style: AppTextStyles.label.copyWith(color: _color)),
    );
  }
}
