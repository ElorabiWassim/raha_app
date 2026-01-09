import 'package:flutter/material.dart';
import 'home_screen_home_owner.dart';
import 'profilehome.dart';
import 'my_services_screen.dart';
import 'messages_screen.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenHomeOwner(),
    MyServicesScreen(),
    MessagesScreen(),
    MyProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.calendar_today_outlined,
    Icons.chat_outlined,
    Icons.person_outline,
  ];
  final List<IconData> _activeIcons = [
    Icons.home,
    Icons.calendar_today,
    Icons.chat,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> labels = [
      l10n.home,
      l10n.bookings,
      l10n.messages,
      l10n.profile,
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withValues(alpha: .1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Active indicator line above the icon
                    if (isSelected)
                      Container(
                        height: 3,
                        width: 20,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Colors.greenAccent, Colors.green],
                          ),
                        ),
                      )
                    else
                      const SizedBox(
                        height: 7,
                      ), // maintain space for inactive items
                    Icon(
                      isSelected ? _activeIcons[index] : _icons[index],
                      color: isSelected ? Colors.green : Colors.grey,
                      size: isSelected ? 28 : 24,
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: isSelected ? Colors.green : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: isSelected ? 12 : 11,
                      ),
                      duration: const Duration(milliseconds: 300),
                      child: Text(labels[index]),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
