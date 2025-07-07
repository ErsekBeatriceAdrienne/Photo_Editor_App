import 'dart:io';
import 'package:flutter/cupertino.dart';

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
}