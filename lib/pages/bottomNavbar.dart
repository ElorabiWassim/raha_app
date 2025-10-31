import 'package:flutter/material.dart';
import './home_screen_home_owner.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: HomeScreenHomeOwner()),
    Center(child: Text(" Bookings")),
    Center(child: Text(" Messages")),
    Center(child: Text(" Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 6)],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: _ActiveIcon(icon: Icons.home, label: "Home"),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom active icon with green arc and filled color
class _ActiveIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActiveIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Green curved line (the arc effect)
        Container(
          height: 3,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Colors.greenAccent, Colors.green],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Icon(icon, color: Colors.green),
      ],
    );
  }
}
