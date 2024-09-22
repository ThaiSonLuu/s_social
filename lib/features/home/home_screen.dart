import 'package:flutter/material.dart';
import 'package:s_social/features/news_feed/presentation/news_feed_screen.dart';
import 'package:s_social/features/post/post_screen.dart';
import 'package:s_social/features/profile/profile_screen.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:s_social/core/cubit/app_language/app_language_cubit.dart';
// import 'package:s_social/core/cubit/app_theme/app_theme_cubit.dart';
// import 'package:s_social/core/cubit/auth/auth_cubit.dart';
// import 'package:s_social/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    NewsFeedScreen(),
    Text('Search Screen'),
    PostScreen(),
    Text('Notifications Screen'),
    ProfileScreen(),
  ];

  static const List<String> _title = [
    'Home', 'Search', 'Post', 'Notifications', 'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_selectedIndex],
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
            label: _selectedIndex == 0 ? 'Home' : '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.search)
                : const Icon(Icons.search_outlined),
            label: _selectedIndex == 0 ? 'Search' : '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.post_add)
                : const Icon(Icons.post_add_outlined),
            label: _selectedIndex == 0 ? 'Post' : '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_outlined),
            label: _selectedIndex == 0 ? 'Notifications' : '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.person)
                : const Icon(Icons.person_outlined),
            label: _selectedIndex == 0 ? 'Profile' : '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        onTap: _onItemTapped,
        showSelectedLabels: false,
      ),
    );
  }
}
