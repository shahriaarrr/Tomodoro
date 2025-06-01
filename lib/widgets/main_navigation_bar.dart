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
    // Retrieve theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // Determine background color for the navigation bar
    final backgroundColor =
        isDarkMode
            ? Theme.of(context).canvasColor
            : Theme.of(context).cardColor;

    return NavigationBar(
      // Set the background based on current mode
      backgroundColor: backgroundColor,

      // Highlight the selected index
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,

      // Define each destination with themed icons
      destinations: [
        NavigationDestination(
          // Selected icon uses primary (warm orange)
          selectedIcon: Icon(Icons.timer, color: primaryColor),
          // Unselected icon uses secondary (teal)
          icon: Icon(Icons.timer_outlined, color: secondaryColor),
          label: 'Timer',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.task_alt, color: primaryColor),
          icon: Icon(Icons.task_alt_outlined, color: secondaryColor),
          label: 'Tasks',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings, color: primaryColor),
          icon: Icon(Icons.settings_outlined, color: secondaryColor),
          label: 'Settings',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person, color: primaryColor),
          icon: Icon(Icons.person_outline, color: secondaryColor),
          label: 'About',
        ),
      ],
    );
  }
}
