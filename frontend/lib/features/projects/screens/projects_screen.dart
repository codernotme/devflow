import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../../theme/app_theme.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/priority_badge.dart';
import '../../../shared/widgets/responsive_layout.dart';
import '../providers/projects_provider.dart';
import '../providers/tasks_provider.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects', style: AppTextStyles.display),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: AppButton.primary(
              label: '+ New Project',
              onPressed: () {
                // Future Implementation: New Project Modal
              },
            ),
          ),
        ],
      ),
      body: ResponsiveLayout(
        child: projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return Center(
                child: Text(
                  'No projects yet. Start one ->',
                  style: AppTextStyles.body,
                ),
              );
            }
            return ListView.separated(
              itemCount: projects.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final project = projects[index];
                final projectTasks =
                    tasksAsync.value
                        ?.where((t) => t.projectId == project.id)
                        .toList() ??
                    [];

                return AppCard(
                  borderColor: project.status == 'done'
                      ? AppColors.accentGreen
                      : null,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(
                        top: AppSpacing.sm,
                      ),
                      title: Row(
                        children: [
                          Text(project.name, style: AppTextStyles.heading2),
                          const SizedBox(width: AppSpacing.sm),
                          PriorityBadge(priority: project.priority),
                        ],
                      ),
                      children: [
                        if (projectTasks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            child: Text(
                              'No sub-tasks.',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ...projectTasks.map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  task.status.name == 'done'
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: task.status.name == 'done'
                                      ? AppColors.accentGreen
                                      : AppColors.textMuted,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: AppTextStyles.body.copyWith(
                                      decoration: task.status.name == 'done'
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.status.name == 'done'
                                          ? AppColors.textMuted
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                PriorityBadge(priority: task.priority),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.accentBlue,
                            ),
                            label: Text(
                              'Add sub-task',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.accentBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
