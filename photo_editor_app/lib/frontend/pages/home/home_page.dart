import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final backgroundColor = Theme.of(context).drawerTheme.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF141414) : Colors.grey[100]);

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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    AppLocalizations.of(context)!.photos_section_text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate(
                    [
                      _buildSection(context, icon: Icons.edit, title: AppLocalizations.of(context)!.edit_page_title, onTap: () {}),
                      _buildSection(context, icon: Icons.crop, title: AppLocalizations.of(context)!.crop_image_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.grid_view_outlined, title: AppLocalizations.of(context)!.collage_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.filter_frames_outlined, title: AppLocalizations.of(context)!.frames_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.grade_outlined, title: AppLocalizations.of(context)!.generate_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.filter, title: AppLocalizations.of(context)!.filters_for_image_button_text, onTap: () {}),
                    ],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 10),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    AppLocalizations.of(context)!.videos_section_text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate(
                    [
                      _buildSection(context, icon: Icons.camera, title: AppLocalizations.of(context)!.clips_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.movie_creation_outlined, title: AppLocalizations.of(context)!.movies_button_text, onTap: () {}),
                      _buildSection(context, icon: Icons.subtitles_outlined, title: AppLocalizations.of(context)!.subtitles_button_text, onTap: () {}),
                    ],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      })
  {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[100];

    return Material(
      color: textColor,
      borderRadius: BorderRadius.circular(20),
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.black.withOpacity(0.1),
        highlightColor: Colors.black.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: Icon(
                  icon,
                  size: 34,
                  color: accentColor,
                ),
              ),
              Positioned(
                left: 4,
                bottom: 12,
                right: 12,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: accentColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}