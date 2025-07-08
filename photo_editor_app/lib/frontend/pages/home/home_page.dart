import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../profile/accent_color_provider.dart';
import '../profile/profile_page.dart';
import '../../../l10n/app_localizations.dart';

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
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final backgroundColor = Theme.of(context).drawerTheme.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF141414)
            : Colors.grey[100]);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Appbar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 70,
                leadingWidth: 90,
                automaticallyImplyLeading: false,
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        final shouldRefresh = await Navigator.push(
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
                      child: widget.userId == null
                          ? const Icon(Icons.person, size: 24)
                          : CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://your-api.com/user/$widget.userId/avatar.jpg',
                        ),
                      ),
                    ),
                  ),
                ],
                // If this enabled than it's blurry
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              // Body
              const SliverPadding(
                padding: EdgeInsets.all(16.0),

              ),

            ],
          ),
        ],
      ),
    );
  }
}