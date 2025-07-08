import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class AiPage extends StatelessWidget {
  const AiPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final String? userId;

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
                floating: false,
                expandedHeight: 70,
                leadingWidth: 90,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  AppLocalizations.of(context)!.profile_page_title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  /*child: Text(
                    userId == null
                        ? AppLocalizations.of(context)!.not_logged_in
                        : '${AppLocalizations.of(context)!.logged_in_as} $userId',
                    style: const TextStyle(fontSize: 18),
                  ),*/
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


