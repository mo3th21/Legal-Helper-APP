import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:qanon/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:qanon/providers/auth_provider_interface.dart';
import 'package:qanon/screens/profile_screen.dart';
import 'package:qanon/theme/app_theme.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      final authProvider =
          Provider.of<AuthProviderInterface>(context, listen: false);
      authProvider.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    // Reserve space at the bottom so the child Scaffold's content is not
    // covered by the persistent CircleNavBar. We add a bottom padding equal
    // to the bar height (56) so inner pages are pushed above the nav.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: _pages[_selectedIndex],
      ),
      extendBody: true,
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.home, color: Colors.white, size: 20),
          Icon(Icons.person, color: Colors.white, size: 20),
          Icon(Icons.logout, color: Colors.white, size: 20),
        ],
        inactiveIcons: const [
          Icon(Icons.home_outlined, color: Colors.white70, size: 18),
          Icon(Icons.person_outline, color: Colors.white70, size: 18),
          Icon(Icons.logout_outlined, color: Colors.white70, size: 18),
        ],
  // package requires these named params: activeIndex and color
  activeIndex: _selectedIndex,
  onTap: (index) => _onItemTapped(index),
  height: 56, // slightly smaller for compact pages
  // circleWidth must be <= height according to the package assertion
  circleWidth: 48,
  circleColor: AppColors.accent,
        color: AppColors.primary,
        cornerRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
    );
  }
}
