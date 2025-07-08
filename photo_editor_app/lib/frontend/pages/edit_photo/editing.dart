import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import 'dart:typed_data';

import '../profile/accent_color_provider.dart';

class EditingPage extends StatefulWidget {
  const EditingPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<EditingPage> createState() => _EditingPageState();
}

class _EditingPageState extends State<EditingPage> {
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
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                floating: false,
                expandedHeight: 70,
                leadingWidth: 90,
                automaticallyImplyLeading: false,
                centerTitle: true,
                // If this enabled than it's blurry
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                    ),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.profile_page_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),

              // Body
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
            ],
          ),
        ],
      ),
    );
  }
}


