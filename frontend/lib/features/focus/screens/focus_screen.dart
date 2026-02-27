import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../providers/timer_provider.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  String _formatDuration(Duration d) {
    if (d.isNegative) return "00:00";
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    final isRunning = timerState.status == TimerStatus.running;
    final isIdle =
        timerState.status == TimerStatus.idle ||
        timerState.status == TimerStatus.completed;

    // Background flash color for break/work states
    Color getBackgroundColor() {
      if (timerState.status == TimerStatus.running) {
        return AppColors.accentPurple.withValues(alpha: 0.05);
      }
      return AppColors.bgPrimary;
    }

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: AppBar(
        title: Text('Focus Timer', style: AppTextStyles.display),
        backgroundColor: Colors.transparent,
      ),
      body: ResponsiveLayout(
        child: Column(
          children: [
            // Timer Display Area
            AppCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(timerState.remaining),
                      style: AppTextStyles.monoTimer.copyWith(
                        color: isRunning
                            ? AppColors.accentPurple
                            : AppColors.textPrimary,
                        fontSize:
                            64, // Making it huge as per UI Guide implicitly
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'WORK SESSION',
                      style: AppTextStyles.caption.copyWith(letterSpacing: 2),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isIdle)
                          AppButton.primary(
                            label: 'Start Focus',
                            onPressed: () => timerNotifier.start(),
                          )
                        else ...[
                          AppButton.ghost(
                            label: isRunning ? 'Pause' : 'Resume',
                            onPressed: () => isRunning
                                ? timerNotifier.pause()
                                : timerNotifier.start(),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          AppButton.danger(
                            label: 'Reset',
                            onPressed: () => timerNotifier.reset(),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Linked Task
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Linked Task', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No task linked',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Link Task',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Today's Sessions (Static / Placeholder for now based on Guide)
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Today's Sessions", style: AppTextStyles.heading2),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (timerState.status == TimerStatus.completed ||
                      timerState.startedAt != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          timerState.startedAt != null
                              ? '${DateFormat('HH:mm').format(timerState.startedAt!)} - Now'
                              : 'Session logged',
                          style: AppTextStyles.monoSmall,
                        ),
                        const Spacer(),
                        Text('Working', style: AppTextStyles.caption),
                      ],
                    )
                  else
                    Text(
                      'No sessions logged today yet.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
