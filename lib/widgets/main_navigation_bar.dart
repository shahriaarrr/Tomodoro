import 'package:flutter/material.dart';

class MainNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isDarkMode;

  const MainNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isDarkMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: isDarkMode ? const Color(0xFF2A2A3E) : Colors.grey[100],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          selectedIcon: Icon(Icons.timer, color: const Color(0xFF6C63FF)),
          icon: Icon(
            Icons.timer_outlined,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          label: 'Timer',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.task_alt, color: const Color(0xFF6C63FF)),
          icon: Icon(
            Icons.task_alt_outlined,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          label: 'Tasks',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings, color: const Color(0xFF6C63FF)),
          icon: Icon(
            Icons.settings_outlined,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          label: 'Settings',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person, color: const Color(0xFF6C63FF)),
          icon: Icon(
            Icons.person_outline,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          label: 'About',
        ),
      ],
    );
  }
}
