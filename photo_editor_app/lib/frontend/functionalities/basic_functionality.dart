import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class Essentials {
  Route createSlideRoute(Widget page) {
    final isWindows = Platform.isWindows;

    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: isWindows ? 10 : 10000),
      reverseTransitionDuration: Duration(milliseconds: isWindows ? 10 : 10000),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String colorToHex(Color color) => '#${color.value.toRadixString(16).padLeft(8, '0')}';
  Color colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse(hex, radix: 16));
  }

  Color lighten(Color color, [double amount = 0.3]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

}