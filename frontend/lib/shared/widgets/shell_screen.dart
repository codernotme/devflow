import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors.dart';
import '../../theme/app_theme.dart';

class ShellScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScreen({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppBreakpoints.tablet) {
          // Tablet/Desktop: Navigation Rail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: AppColors.bgSurface,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _goBranch,
                  extended: constraints.maxWidth >= AppBreakpoints.desktop,
                  indicatorColor: AppColors.accentBlue.withValues(alpha: 0.2),
                  selectedIconTheme: const IconThemeData(
                    color: AppColors.accentBlue,
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: AppColors.textMuted,
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: AppColors.accentBlue,
                  ),
                  unselectedLabelTextStyle: const TextStyle(
                    color: AppColors.textMuted,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_rounded),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.folder_rounded),
                      label: Text('Projects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.timer_rounded),
                      label: Text('Focus'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.edit_note_rounded),
                      label: Text('Standup'),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: AppColors.bgBorder,
                ),
                Expanded(child: navigationShell),
              ],
            ),
          );
        } else {
          // Mobile: Bottom Navigation Bar
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _goBranch,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_rounded),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer_rounded),
                  label: 'Focus',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_note_rounded),
                  label: 'Standup',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
