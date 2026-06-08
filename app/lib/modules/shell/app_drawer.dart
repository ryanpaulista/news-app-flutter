import 'package:app/app/routes.dart';
import 'package:flutter/material.dart';

/// Complementary actions shared across all tabs (requirement #2).
///
/// Every action targets the ROOT navigator (`rootNavigator: true`) so that
/// Settings is pushed *over* the bottom bar and Logout replaces the whole
/// shell — not just the current tab's nested navigator.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _openSettings(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    debugPrint('[Drawer] root push ${AppRoutes.settings}');
    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.settings);
  }

  void _logout(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    debugPrint('[Drawer] root pushReplacement ${AppRoutes.login}');
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed(AppRoutes.login);
  }

  void _showAbout(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    debugPrint('[Drawer] showDialog Sobre');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sobre'),
        content: const Text(
          'NewsHub\nVersão 1.0.0\n\n'
          'App de demonstração de navegação (Drawer + BottomNavigationBar) '
          'usando Navigators aninhados e rotas nomeadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'NewsHub',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => _openSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre'),
            onTap: () => _showAbout(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
