import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../pages/edited_files/edited_files_page.dart';
import '../pages/editing_image/edit_images_page.dart';
import '../pages/editing_video/edit_videos_page.dart';
import '../pages/generate_ai/ai.dart';
import '../../../l10n/app_localizations.dart';
import '../pages/profile/accent_color_provider.dart';
import '../pages/profile/profile_page.dart';

class PhoneMenu extends StatefulWidget
{
  final VoidCallback toggleTheme;
  final String? userId;
  final bool isDarkMode;

  const PhoneMenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  _PhoneMenuState createState() => _PhoneMenuState();
}

class _PhoneMenuState extends State<PhoneMenu>
{
  int _currentIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initPages();
  }

  void _initPages() {
    _pages.addAll([
      EditImagesPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      EditVideosPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      AiPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      EditedFilesPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      ProfilePage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
    ]);
  }

  /*Future<void> _preloadUserName() async
  {
    try
    {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirestoreDocs.user_doc)
          .doc(widget.userId)
          .get(const GetOptions(source: Source.cache));

      if (!snapshot.exists)
      {
        snapshot = await FirebaseFirestore.instance
            .collection(FirestoreDocs.user_doc)
            .doc(widget.userId)
            .get();
      }

      var userData = snapshot.data() as Map<String, dynamic>? ?? {};
      String username = userData[FirestoreDocs.userUsername] ?? 'Unknown user';

      setState(() {
        _username = username;
      });
    } catch (e) {
      setState(() {
        _username = 'Error';
      });
    }
  }*/

  void _onTap(int index)
  {
    if (index != _currentIndex) {
      HapticFeedback.heavyImpact();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final backgroundColor = Theme.of(context).drawerTheme.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF141414)
            : Colors.grey[100]);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _pages[_currentIndex],

          // Menu bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                  child: Container(
                    color: backgroundColor?.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.insert_photo_outlined, 0, accentColor),
                        _buildNavItem(Icons.camera_roll_outlined, 1, accentColor),
                        _buildNavItem(Icons.generating_tokens_outlined, 2, accentColor),
                        _buildNavItem(Icons.folder_open_rounded, 3, accentColor),
                        _buildNavItem(Icons.person, 4, accentColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color accentColor) {
    bool isSelected = _currentIndex == index;
    Color defaultColor = Theme.of(context).iconTheme.color ??
        (widget.isDarkMode ? Colors.grey.shade600 : Colors.black87);

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (rect) => LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.8),
                    accentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect),
                child: Icon(
                  icon,
                  size: 25.0,
                ),
              )
            else
              Icon(
                icon,
                color: defaultColor.withOpacity(0.7),
                size: 25.0,
              ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}