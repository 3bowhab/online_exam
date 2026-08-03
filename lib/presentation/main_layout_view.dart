import 'package:flutter/material.dart';
import 'package:online_exam/core/l10n/app_localizations.dart';
import 'package:online_exam/presentation/profile/view/profile_view.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  int _currentIndex = 2;

  final List<Widget> _pages = const [
    Center(child: Text('Explore Screen')),
    Center(child: Text('Result Screen')),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigationBar(locale, theme),
    );
  }

  Widget _buildBottomNavigationBar(AppLocalizations locale, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _buildNavItems(locale),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavItems(AppLocalizations locale) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home_outlined),
        activeIcon: const Icon(Icons.home),
        label: locale.exploreTab,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.assignment_outlined),
        activeIcon: const Icon(Icons.assignment),
        label: locale.resultTab,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: locale.profileTab,
      ),
    ];
  }
}
