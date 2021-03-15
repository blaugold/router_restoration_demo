import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';

import '../routing/app_routing.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appRouting = context.watch<AppRouting>();

    final Widget body;
    switch (appRouting.mainNavigation) {
      case MainNavigation.content:
        body = _buildContent();
        break;
      case MainNavigation.settings:
        body = _buildSettings();
        break;
      case MainNavigation.profile:
        body = _buildProfile();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: MainNavigation.values.indexOf(appRouting.mainNavigation),
        onTap: (index) =>
            appRouting.mainNavigation = MainNavigation.values[index],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: ButtonBar(
        mainAxisSize: MainAxisSize.min,
        children: [
          Link(
            uri: Uri.parse('/content/photos'),
            builder: (context, followLink) => TextButton(
              onPressed: followLink,
              child: Text('Photos'),
            ),
          ),
          Link(
            uri: Uri.parse('/content/messages'),
            builder: (context, followLink) => TextButton(
              onPressed: followLink,
              child: Text('Messages'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Center(
      child: Text('Settings'),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Text('Profile'),
    );
  }
}
