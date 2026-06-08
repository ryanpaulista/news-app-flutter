import 'package:app/app/routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onMenuTap;

  const ProfileScreen({super.key, required this.onMenuTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Nicollas';

  Future<void> _editProfile() async {
    debugPrint('[Profile] push ${AppRoutes.editProfile} current=$_name');
    final result = await Navigator.of(
      context,
    ).pushNamed(AppRoutes.editProfile, arguments: _name);
    debugPrint('[Profile] back from edit-profile, result=$result');

    if (!mounted) return;
    if (result is String && result.isNotEmpty) {
      setState(() => _name = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nome atualizado para "$result"')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Menu',
          onPressed: widget.onMenuTap,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 16),
            Text(
              _name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${_name.toLowerCase()}@newshub.com',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
