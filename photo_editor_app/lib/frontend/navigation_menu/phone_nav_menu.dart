import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/collages/collage_main_page.dart';
import '../pages/erase_background/eraser.dart';
import '../pages/home/home_page.dart';

class AndroidMenu extends StatefulWidget
{
  final VoidCallback toggleTheme;
  final String? userId;
  final bool isDarkMode;

  const AndroidMenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  _AndroidMenuState createState() => _AndroidMenuState();
}

class _AndroidMenuState extends State<AndroidMenu>
{
  int _currentIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState()
  {
    super.initState();
    _pages.addAll([
      HomePage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      CollagePage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode),
      EraseBackgroundPage(onToggleTheme: widget.toggleTheme, userId: widget.userId, isDarkMode: widget.isDarkMode)
    ]);
    //_preloadUserName();
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
    return Scaffold(
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
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.color_lens_outlined, 0),
                        _buildNavItem(Icons.view_agenda_outlined, 1),
                        _buildNavItem(Icons.compare, 2),
                        _buildNavItem(Icons.diamond_outlined, 3),
                        _buildNavItem(Icons.folder_open_rounded, 4),
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

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  colors: isSelected
                      ? [Colors.blue, Colors.blueAccent]
                      : [Colors.grey.shade400, Colors.black12],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect);
              },
              child: Icon(
                icon,
                color: Colors.white,
                size: 31.0,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

}