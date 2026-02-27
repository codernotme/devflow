import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({super.key, required this.child});

  Widget _buildSingleColumn(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: child,
    );
  }

  Widget _buildTwoColumn(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: child,
        ),
      ),
    );
  }

  Widget _buildThreeColumn(BuildContext context, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          return _buildThreeColumn(context, constraints);
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          return _buildTwoColumn(context, constraints);
        } else {
          return _buildSingleColumn(context, constraints);
        }
      },
    );
  }
}
