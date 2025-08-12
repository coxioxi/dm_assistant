import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'combat_screen.dart';
import 'player_screen.dart';
import 'monsters_screen.dart';
import 'dice_roll_screen.dart';
import 'initiatives.dart';
import 'config_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _MainScreen());
  }
}

class _MainScreen extends StatefulWidget {
  @override
  State<_MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  int _selectedItemIndex = 0;

  final List<Widget> _pages = [
    CombatScreen(),
    PlayerScreen(),
    MonstersScreen(),
    DiceRollScreen(),
    Initiatives(),
    ConfigScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedItemIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItemIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gun),
            label: "Combat",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.person),
            label: "Players",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.dragon),
            label: "Monsters",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.diceD20),
            label: "Roll Dice",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userClock),
            label: "Initiatives",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: 'Options',
          ),
        ],
      ),
    );
  }
}
