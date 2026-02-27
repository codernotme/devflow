import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/responsive_layout.dart';
import 'package:frontend/features/projects/providers/tasks_provider.dart';
import 'package:frontend/features/projects/providers/projects_provider.dart';
import 'package:frontend/features/focus/providers/timer_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final projectsAsync = ref.watch(projectsProvider);
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      body: ResponsiveLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning, Dev', style: AppTextStyles.display),
            const SizedBox(height: AppSpacing.md),
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active Focus', style: AppTextStyles.caption),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          timerState.status == TimerStatus.running
                              ? 'Running'
                              : 'Idle',
                          style: AppTextStyles.monoSmall.copyWith(
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tasks Done', style: AppTextStyles.caption),
                        const SizedBox(height: AppSpacing.sm),
                        tasksAsync.when(
                          data: (tasks) {
                            final done = tasks
                                .where((t) => t.status.name == 'done')
                                .length;
                            return Text(
                              '$done',
                              style: AppTextStyles.monoSmall.copyWith(
                                color: AppColors.accentGreen,
                              ),
                            );
                          },
                          loading: () => const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ),
                          error: (err, stack) =>
                              Text('Err', style: AppTextStyles.monoSmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Today\'s Tasks', style: AppTextStyles.heading1),
            const SizedBox(height: AppSpacing.md),
            tasksAsync.when(
              data: (tasks) {
                final visibleTasks = tasks.take(5).toList();
                if (visibleTasks.isEmpty) return const Text('No tasks today.');
                return Column(
                  children: visibleTasks
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            child: Row(
                              children: [
                                Icon(
                                  t.status.name == 'done'
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: t.status.name == 'done'
                                      ? AppColors.accentGreen
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    t.title,
                                    style: AppTextStyles.body.copyWith(
                                      decoration: t.status.name == 'done'
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: t.status.name == 'done'
                                          ? AppColors.textMuted
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                StatusChip(status: t.status),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading tasks: $err'),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text('Active Projects', style: AppTextStyles.heading1),
            const SizedBox(height: AppSpacing.md),
            projectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) return const Text('No active projects.');
                return Column(
                  children: projects
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            borderColor: p.status == 'done'
                                ? AppColors.accentGreen
                                : AppColors.bgBorder,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(p.name, style: AppTextStyles.heading2),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading projects: $err'),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton.primary(
              label: 'Start Focus',
              onPressed: () => context.go('/focus'),
            ),
          ],
        ),
      ),
    );
  }
}
