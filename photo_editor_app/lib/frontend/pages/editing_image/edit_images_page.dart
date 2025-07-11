import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
import 'package:photo_editor_app/frontend/pages/editing_image/edit_mode/edit_page.dart';
import 'package:provider/provider.dart';
import '../profile/accent_color_provider.dart';
import '../profile/profile_page.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

class EditImagesPage extends StatefulWidget {
  const EditImagesPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<EditImagesPage> createState() => _EditImagesPageState();
}

class _EditImagesPageState extends State<EditImagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider
        .of<AccentColorProvider>(context)
        .accentColor;
    final backgroundColor = Theme
        .of(context)
        .drawerTheme
        .backgroundColor ??
        (Theme
            .of(context)
            .brightness == Brightness.dark
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
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                pinned: false,
                expandedHeight: 50,
                leadingWidth: 90,
                automaticallyImplyLeading: false,
                centerTitle: true,
                floating: true,
                snap: true,
                // If this enabled than it's blurry
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      color: backgroundColor?.withOpacity(0.5),
                    ),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.photo_editing_page_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),

              // Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Text(
                    AppLocalizations.of(context)!.photos_section_text,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),


            ],
          ),
        ],
      ),
    );
  }
}