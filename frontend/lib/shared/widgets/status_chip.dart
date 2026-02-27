import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../../features/projects/models/task_status.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;

  const StatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.bgBorder;
      case TaskStatus.inProgress:
        return AppColors.accentAmber;
      case TaskStatus.done:
        return AppColors.accentGreen;
      case TaskStatus.blocked:
        return AppColors.accentRed;
    }
  }

  Color get _textColor {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.textMuted;
      case TaskStatus.inProgress:
      case TaskStatus.done:
      case TaskStatus.blocked:
        return AppColors.textInverse;
    }
  }

  String get _label {
    switch (status) {
      case TaskStatus.todo:
        return 'TODO';
      case TaskStatus.inProgress:
        return 'IN PROGRESS';
      case TaskStatus.done:
        return 'DONE';
      case TaskStatus.blocked:
        return 'BLOCKED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: AppTextStyles.label.copyWith(color: _textColor, fontSize: 10),
      ),
    );
  }
}
