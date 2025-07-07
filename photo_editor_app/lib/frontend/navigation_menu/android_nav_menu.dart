import 'dart:ui';
import 'package:flutter/material.dart';

class AndroidNavMenu extends StatefulWidget
{
  final VoidCallback toggleTheme;
  final String? userId;

  const AndroidNavMenu({
    super.key,
    required this.toggleTheme,
    required this.userId,
  });

  @override
  _AndroidNavMenuState createState() => _AndroidNavMenuState();
}

class _AndroidNavMenuState extends State<AndroidNavMenu> {
  int _currentIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    /*_pages.addAll([
      /*DataStructuresPage(toggleTheme: widget.toggleTheme, userId: widget.userId),
      AlgorithmsPage(toggleTheme: widget.toggleTheme, userId: widget.userId),
      widget.userId != null
          ? CCompilerPage(toggleTheme: widget.toggleTheme, userId: widget.userId)
          : LoginRequiredPage(toggleTheme: widget.toggleTheme),
      widget.userId != null
          ? TestsPage(toggleTheme: widget.toggleTheme, userId: widget.userId)
          : LoginRequiredPage(toggleTheme: widget.toggleTheme),
      widget.userId != null
          ? ProfilePage(toggleTheme: widget.toggleTheme, userId: widget.userId)
          : LoginRequiredPage(toggleTheme: widget.toggleTheme),*/
    ]);*/
    //_preloadUserName();
  }

  /*Future<void> _preloadUserName() async
  {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirestoreDocs.user_doc)
          .doc(widget.userId)
          .get(const GetOptions(source: Source.cache));

      if (!snapshot.exists) {
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
  }

  void _onTap(int index) {
    if (index != _currentIndex) {
      HapticFeedback.heavyImpact();
      setState(() {
        _currentIndex = index;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*This is the rounded rectangle version
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),//color: Colors.transparent,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.storage, 1),
                  _buildNavItem(Icons.code, 2),
                  _buildNavItem(Icons.terminal_rounded, 3),
                  _buildNavItem(Icons.person, 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );*/
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
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home_outlined, 0),
                        _buildNavItem(Icons.code_rounded, 1),
                        _buildNavItem(Icons.terminal_rounded, 2),
                        _buildNavItem(Icons.quiz_outlined, 3),
                        _buildNavItem(Icons.perm_identity_rounded, 4),
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
      //onTap: () => _onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Apply gradient if the item is selected
            isSelected
                ? ShaderMask(
              shaderCallback: (rect) =>
                  const LinearGradient(
                    colors: [
                      Color(0xFF255f38),
                      Color(0xFF1f7d53),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(rect),
              child: Icon(
                icon,
                color: Colors.white,
                size: 31.0,
              ),
            )
                : Icon(
              icon,
              color: Colors.black,
              size: 31.0,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}