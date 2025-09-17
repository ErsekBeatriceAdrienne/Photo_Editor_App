import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image/image.dart' as img_pkg;
import 'package:file_selector/file_selector.dart';
import 'package:path_provider/path_provider.dart';

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
    required this.imageBytes,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;
  final Uint8List imageBytes;

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final CropController _cropController = CropController();
  Uint8List? _editedImage;
  bool _isCropping = false;
  bool _isProcessing = false;

  Uint8List get _displayedImage => _editedImage ?? widget.imageBytes;

  void _startCrop() {
    setState(() => _isCropping = true);
  }

  void _performCrop() {
    setState(() => _isProcessing = true);
    _cropController.crop();
  }

  Future<void> _rotate90() async {
    setState(() => _isProcessing = true);
    try {
      final data = _displayedImage;

      final decoded = img_pkg.decodeImage(data);
      if (decoded == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nem sikerült dekódolni a képet.')),
        );
        return;
      }

      final rotated = img_pkg.copyRotate(decoded, angle: 90);
      final rotatedBytes = Uint8List.fromList(img_pkg.encodePng(rotated));

      setState(() {
        _editedImage = rotatedBytes;
      });

      if (_isCropping) {
        _cropController.image = rotatedBytes;
      }

    } catch (e, st) {
      debugPrint('Rotate error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Forgatás hiba: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _saveImage(Uint8List bytes) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop
      try {
        final typeGroup = XTypeGroup(label: 'PNG Image', extensions: ['png']);
        final path = await getSavePath(
          acceptedTypeGroups: [typeGroup],
          suggestedName: 'edited_image.png',
        );
        if (path == null) return;
        final file = File(path);
        await file.writeAsBytes(bytes);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kép elmentve: $path')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mentés sikertelen: $e')),
        );
      }
    } else {
      // Mobile
      final dir = await getApplicationDocumentsDirectory();
      String fileName = 'edited_image.png';

      final controller = TextEditingController(text: fileName);
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mentés fájlnévvel'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Fájlnév'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Mégse'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Mentés'),
            ),
          ],
        ),
      );

      if (result == null) return;
      fileName = result.endsWith('.png') ? result : '$result.png';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kép elmentve: ${file.path}')),
      );
    }
  }

  void _onCropped(CropResult result) {
    setState(() {
      _isProcessing = false;
      _isCropping = false;
    });

    if (result is CropSuccess) {
      final bytes = result.croppedImage;
      setState(() {
        _editedImage = bytes;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kép kivágva.')),
      );
    } else if (result is CropFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vágás hiba: ${result}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ismeretlen eredmény a vágásnál.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.memory(_displayedImage),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 84,
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.35)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Kép vágása',
                        onPressed: _isProcessing ? null : _startCrop,
                        icon: const Icon(Icons.crop, size: 26),
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      IconButton(
                        tooltip: 'Elforgatás 90°',
                        onPressed: _isProcessing ? null : _rotate90,
                        icon: const Icon(Icons.rotate_right, size: 26),
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      IconButton(
                        tooltip: 'Mentés',
                        onPressed: _isProcessing ? null : () => _saveImage(_displayedImage),
                        icon: const Icon(Icons.save, size: 26),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_isCropping)
            Positioned.fill(
              child: Material(
                color: Colors.black.withOpacity(0.75),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _isProcessing ? null : () {
                              setState(() => _isCropping = false);
                            },
                            child: const Text('Mégse', style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Rotate 90°',
                                onPressed: _isProcessing ? null : _rotate90,
                                icon: const Icon(Icons.rotate_right, color: Colors.white),
                              ),
                              IconButton(
                                tooltip: 'Vágás végrehajtása',
                                onPressed: _isProcessing ? null : _performCrop,
                                icon: const Icon(Icons.check, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Colors.black,
                                child: Crop(
                                  controller: _cropController,
                                  image: _displayedImage,
                                  onCropped: _onCropped,
                                  baseColor: Colors.black,
                                  maskColor: Colors.white.withAlpha(120),
                                  cornerDotBuilder: (size, edge) => const DotControl(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
