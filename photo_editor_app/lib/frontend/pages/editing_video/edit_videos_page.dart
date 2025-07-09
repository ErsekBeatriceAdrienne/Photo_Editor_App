import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:typed_data';

import '../profile/accent_color_provider.dart';

class EditVideosPage extends StatefulWidget {
  const EditVideosPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<EditVideosPage> createState() => _EditVideosPageState();
}

class _EditVideosPageState extends State<EditVideosPage> {
  List<AssetEntity> _images = [];
  late final VoidCallback onToggleTheme;
  late final bool isDarkMode;
  late final String? userId;

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!Platform.isAndroid && !Platform.isIOS) return;

    if (ps.isAuth) {
      await PhotoManager.clearFileCache();

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isNotEmpty) {
        final recent = albums.first;
        final List<AssetEntity> media = await recent.getAssetListPaged(page: 0, size: 50);
        setState(() {
          _images = media;
        });
      }
    } else {
      setState(() {
        _images = [];
      });
    }
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
                  AppLocalizations.of(context)!.videos_editing_page_title,
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

              /*
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: _images.isNotEmpty
                    ? SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return FutureBuilder<Uint8List?>(
                        future: _images[index].thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Image.memory(snapshot.data!, fit: BoxFit.cover);
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                    childCount: _images.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                )
                    : const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),

               */
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


