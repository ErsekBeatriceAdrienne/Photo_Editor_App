import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../functionalities/basic_functionality.dart';

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
    Color(0xFFFFC1E3),
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
                        ? const Icon(Icons.check, color: Colors.blueAccent)
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


class AccentColorProvider extends ChangeNotifier {
  Color _accentColor = Colors.blueAccent;

  Color get accentColor => _accentColor;

  AccentColorProvider() {
    _loadAccentColor();
  }

  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('accentColor');
    _accentColor = colorString == null
        ? Colors.blueAccent
        : Essentials().colorFromHex(colorString);
    notifyListeners();
  }

  Future<void> setAccentColor(Color newColor) async {
    _accentColor = newColor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentColor', '#${newColor.value.toRadixString(16).padLeft(8, '0')}');
    notifyListeners();
  }
}
