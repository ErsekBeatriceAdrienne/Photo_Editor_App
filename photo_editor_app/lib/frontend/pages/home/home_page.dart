import 'dart:ui';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(AppLocalizations.of(context)!.permission_required_message,
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDFAEE8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}