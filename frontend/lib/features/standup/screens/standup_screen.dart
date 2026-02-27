import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../theme/typography.dart';
import '../../../theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/responsive_layout.dart';

class StandupScreen extends ConsumerStatefulWidget {
  const StandupScreen({super.key});

  @override
  ConsumerState<StandupScreen> createState() => _StandupScreenState();
}

class _StandupScreenState extends ConsumerState<StandupScreen> {
  final _yesterdayController = TextEditingController();
  final _todayController = TextEditingController();
  final _blockersController = TextEditingController();
  DateTime _currentDate = DateTime.now();

  @override
  void dispose() {
    _yesterdayController.dispose();
    _todayController.dispose();
    _blockersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read logic could go here to auto-fill depending on _currentDate
    final dateStr = DateFormat('MMM d, yyyy').format(_currentDate);

    // Read logic could go here to auto-fill depending on _currentDate

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Standup', style: AppTextStyles.display),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: AppButton.ghost(
              label: 'Copy as Text',
              onPressed: () {
                // Future Implementation: Copy to clipboard
              },
            ),
          ),
        ],
      ),
      body: ResponsiveLayout(
        child: Column(
          children: [
            // Date navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(
                      () => _currentDate = _currentDate.subtract(
                        const Duration(days: 1),
                      ),
                    );
                  },
                ),
                Text(dateStr, style: AppTextStyles.heading2),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentDate.day == DateTime.now().day
                      ? null
                      : () => setState(
                          () => _currentDate = _currentDate.add(
                            const Duration(days: 1),
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Yesterday', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              hintText: 'What did you complete?',
              controller: _yesterdayController,
              minLines: 3,
              maxLines: 10,
            ),
            const SizedBox(height: AppSpacing.lg),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Today', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              hintText: 'What\'s planned?',
              controller: _todayController,
              minLines: 3,
              maxLines: 10,
            ),
            const SizedBox(height: AppSpacing.lg),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Blockers', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              hintText: 'Any blockers? (Empty means No Blockers!)',
              controller: _blockersController,
              minLines: 2,
              maxLines: 5,
            ),

            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: AppButton.ghost(
                    label: 'Auto-fill from logs',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: 'Save Standup',
                    onPressed: () {
                      // Call backend
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
