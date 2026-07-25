import 'package:bongkob_project_v2/ui/screens/decode/decode_screen.dart';
import 'package:bongkob_project_v2/ui/screens/encode/encode_home_screen.dart';
import 'package:bongkob_project_v2/ui/screens/profile_screen.dart';
import 'package:bongkob_project_v2/ui/screens/vault_screen.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

enum AppTab { encode, decode, vault, profile }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AppTab currentTab = AppTab.encode; // set default screen to Encode Home Screen

  // get current screen
  Widget currentScreen(AppTab tab) {
    switch (tab) {
      case AppTab.encode:
        return const EncodeHomeScreen();
      case AppTab.decode:
        return const DecodeScreen();
      case AppTab.vault:
        return const VaultScreen();
      case AppTab.profile:
        return const ProfileScreen();
    }
  }

  //build bottom navigation bar
  //AppTab.values will generate a list of enum [AppTab.encode, AppTab.decode, AppTab.vault, AppTab.profile]
  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex:
          currentTab.index, // to highlight which icon is currently active
      onTap: (index) {
        setState(() {
          print(index); //for simulate index (tab)
          currentTab = AppTab.values[index];
        });
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: AppTheme.background,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Encode'),
        BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: 'Decode'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Vault'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen(currentTab),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
