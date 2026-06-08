import 'package:app/app/routes.dart';
import 'package:app/modules/shell/app_drawer.dart';
import 'package:app/modules/shell/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  int _currentTab = 0;

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  void _onTabSelected(int index) {
    if (index == _currentTab) {
      debugPrint('[Shell] re-tap tab $index -> popUntil first');
      _navKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      debugPrint('[Shell] switch tab $_currentTab -> $index');
      setState(() => _currentTab = index);
    }
  }

  void _handleBack(bool didPop) {
    if (didPop) return;

    final ScaffoldState? scaffold = _scaffoldKey.currentState;
    if (scaffold != null && scaffold.isDrawerOpen) {
      debugPrint('[Shell] back -> close drawer');
      scaffold.closeDrawer();
      return;
    }

    final NavigatorState? navigator = _navKeys[_currentTab].currentState;
    if (navigator != null && navigator.canPop()) {
      debugPrint('[Shell] back -> pop tab $_currentTab nested navigator');
      navigator.pop();
      return;
    }

    if (_currentTab != 0) {
      debugPrint('[Shell] back -> return to Início (tab 0)');
      setState(() => _currentTab = 0);
      return;
    }

    debugPrint('[Shell] back -> exit app');
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _handleBack(didPop),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: _currentTab,
          children: [
            TabNavigator(
              navigatorKey: _navKeys[0],
              initialRoute: AppRoutes.home,
              onMenuTap: _openDrawer,
              onOpenFavorites: () => _onTabSelected(1),
            ),
            TabNavigator(
              navigatorKey: _navKeys[1],
              initialRoute: AppRoutes.favorites,
              onMenuTap: _openDrawer,
            ),
            TabNavigator(
              navigatorKey: _navKeys[2],
              initialRoute: AppRoutes.profile,
              onMenuTap: _openDrawer,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: _onTabSelected,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
