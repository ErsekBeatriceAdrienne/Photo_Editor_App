import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor_app/frontend/functionalities/basic_functionality.dart';
import 'package:photo_editor_app/frontend/pages/editing_image/edit_mode/edit_page.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import '../profile/accent_color_provider.dart';
import '../../../l10n/app_localizations.dart';

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
  Widget build(BuildContext context) {
    final accentColor = Provider.of<AccentColorProvider>(context).accentColor;
    final backgroundColor = Theme.of(context).drawerTheme.backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF141414)
            : Colors.grey[100]);

    final bool isMobile = Platform.isAndroid || Platform.isIOS;
    final bool isDesktop = Platform.isWindows || Platform.isMacOS;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: isMobile
          ? _buildMobileBody(context, accentColor, backgroundColor)
          : _buildDesktopBody(context, accentColor, backgroundColor),
    );
  }

  // Mobile body
  Widget _buildMobileBody(
      BuildContext context, Color accentColor, Color? backgroundColor) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBarMobile(context, accentColor, backgroundColor),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.photos_section_text,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _buildSection(
                      context,
                      icon: Icons.edit,
                      title:
                      AppLocalizations.of(context)!.edit_page_title,
                      onTap: _handleImageSelection,
                    ),
                    _buildSection(
                      context,
                      icon: Icons.crop,
                      title: AppLocalizations.of(context)!
                          .crop_image_button_text,
                      onTap: () {},
                    ),
                    _buildSection(
                      context,
                      icon: Icons.grid_view_outlined,
                      title:
                      AppLocalizations.of(context)!.collage_button_text,
                      onTap: () {},
                    ),
                    _buildSection(
                      context,
                      icon: Icons.filter_frames_outlined,
                      title:
                      AppLocalizations.of(context)!.frames_button_text,
                      onTap: () {},
                    ),
                    _buildSection(
                      context,
                      icon: Icons.grade_outlined,
                      title:
                      AppLocalizations.of(context)!.generate_button_text,
                      onTap: () {},
                    ),
                    _buildSection(
                      context,
                      icon: Icons.filter,
                      title: AppLocalizations.of(context)!
                          .filters_for_image_button_text,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBarMobile(
      BuildContext context, Color accentColor, Color? backgroundColor)
  {
    return SliverAppBar(
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
    final textColor =
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[100];

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

  Widget _buildDesktopBody(
      BuildContext context, Color accentColor, Color? backgroundColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Ez az asztali verzió képszerkesztője",
            style: TextStyle(color: accentColor, fontSize: 20),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );

              if (result != null) {
                final file = File(result.files.single.path!);
                final bytes = await file.readAsBytes();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditPhotoPage(
                      onToggleTheme: widget.onToggleTheme,
                      isDarkMode: widget.isDarkMode,
                      userId: widget.userId,
                      imageBytes: bytes,
                    ),
                  ),
                );
              }
            },
            child: const Text("Kép kiválasztása"),
          ),

        ],
      ),
    );
  }

  Future<void> _handleImageSelection() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) return;

    final List<AssetPathEntity> albums =
    await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albums.isEmpty) return;

    final List<AssetEntity> images =
    await albums.first.getAssetListPaged(page: 0, size: 100);
    if (images.isEmpty) return;

    final selected = await showDialog<AssetEntity>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Válassz egy képet"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: images[index]
                    .thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  return GestureDetector(
                    onTap: () => Navigator.pop(context, images[index]),
                    child: Image.memory(snapshot.data!, fit: BoxFit.cover),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    if (selected == null) return;
    final file = await selected.file;
    if (file == null) return;
    final Uint8List imageData = await file.readAsBytes();

    if (context.mounted) {
      Navigator.push(
        context,
        Essentials().createSlideRoute(
          EditPhotoPage(
            onToggleTheme: widget.onToggleTheme,
            isDarkMode: widget.isDarkMode,
            userId: widget.userId,
            imageBytes: imageData,
          ),
        ),
      );
    }
  }
}
