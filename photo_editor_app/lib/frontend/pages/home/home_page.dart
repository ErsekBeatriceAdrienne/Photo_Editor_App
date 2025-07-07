import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
import '../profile/profile_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final String? userId = widget.userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  Essentials().createSlideRoute(
                    ProfilePage(
                      onToggleTheme: widget.onToggleTheme,
                      isDarkMode: widget.isDarkMode,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
              child: userId == null
                  ? const Icon(Icons.person, size: 24)
                  : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://your-api.com/user/$userId/avatar.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(

      ),
    );
  }
}