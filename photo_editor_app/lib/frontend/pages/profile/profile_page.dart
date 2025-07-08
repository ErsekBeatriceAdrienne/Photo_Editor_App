import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../language_support/language_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color _accentColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _loadAccentColor();
  }

  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('accentColor') ?? '#448AFF';
    setState(() {
      _accentColor = _colorFromHex(colorString);
    });
  }

  Future<void> _setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentColor', _colorToHex(color));
    setState(() {
      _accentColor = color;
    });
  }

  String _colorToHex(Color color) => '#${color.value.toRadixString(16).padLeft(8, '0')}';

  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse(hex, radix: 16));
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
                leading: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: _accentColor,
                    padding: const EdgeInsets.only(left: 8.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.back_button_text,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                    ),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.profile_page_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _accentColor,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: LanguagePicker(isDarkMode: widget.isDarkMode),
                  ),
                  IconButton(
                    icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    onPressed: widget.onToggleTheme,
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    icon: const Icon(Icons.palette, size: 32),
                    color: _accentColor,
                    tooltip: 'Accent szín kiválasztása',
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => AccentColorPickerBottomSheet(
                          currentColor: _accentColor,
                          onColorSelected: (newColor) async {
                            await _setAccentColor(newColor);
                            Navigator.pop(context, true); 
                          },
                        ),
                      );
                    },
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

class AccentColorPickerBottomSheet extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorSelected;

  const AccentColorPickerBottomSheet({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  final List<Color> _colors = const [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pinkAccent,
    Color(0xFFFFC1E3), // PinkAccent.shade100 alternatíva
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          const ListTile(
            title: Text('Válassz egy színt', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onColorSelected(color);
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 24,
                    child: color == currentColor
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

