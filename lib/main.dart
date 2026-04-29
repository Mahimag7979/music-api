import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/background.dart';
import 'providers/player_provider.dart';
import 'screens/home_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/favourites_screen.dart';
import 'widgets/mini_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerProvider()..init(),
      child: const MusicPlayerApp(),
    ),
  );
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RhythmAlchemist',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayerProvider>();

    const List<Widget> screens = [
      HomeScreen(),
      FavouritesScreen(),
      DownloadsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: screens[provider.navIndex],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            currentIndex: provider.navIndex,
            onTap: provider.setNavIndex,
            backgroundColor: Colors.black.withValues(alpha: 0.85),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favourites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.download_done),
                label: 'Downloads',
              ),
            ],
          ),
        ],
      ),
    );
  }
}