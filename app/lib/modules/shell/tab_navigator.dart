import 'package:app/app/routes.dart';
import 'package:app/core/models/article.dart';
import 'package:app/modules/article/news_detail_screen.dart';
import 'package:app/modules/favorites/favorites_screen.dart';
import 'package:app/modules/home/home.dart';
import 'package:app/modules/profile/edit_profile_screen.dart';
import 'package:app/modules/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;
  final VoidCallback onMenuTap;

  final VoidCallback? onOpenFavorites;

  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.initialRoute,
    required this.onMenuTap,
    this.onOpenFavorites,
  });

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    debugPrint('[TabNavigator $initialRoute] generate "${settings.name}"');

    late final Widget page;
    switch (settings.name) {
      case AppRoutes.home:
        page = HomePage(
          onMenuTap: onMenuTap,
          onOpenFavorites: onOpenFavorites ?? () {},
        );
      case AppRoutes.favorites:
        page = FavoritesScreen(onMenuTap: onMenuTap);
      case AppRoutes.profile:
        page = ProfileScreen(onMenuTap: onMenuTap);
      case AppRoutes.article:
        final article = settings.arguments as Article;
        page = NewsDetailScreen(article: article);
      case AppRoutes.editProfile:
        final name = settings.arguments as String;
        page = EditProfileScreen(currentName: name);
      default:
        page = Scaffold(
          body: Center(child: Text('Rota desconhecida: ${settings.name}')),
        );
    }

    return MaterialPageRoute<dynamic>(builder: (_) => page, settings: settings);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (navigator, initialRouteName) =>
          [_onGenerateRoute(RouteSettings(name: initialRouteName))],
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
