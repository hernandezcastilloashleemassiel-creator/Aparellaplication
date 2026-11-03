import 'package:flutter/material.dart';
import '../modelo/user_modelo.dart';

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const UserSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar usuario...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE8E6FA),
          child: Icon(
            Icons.person,
            color: Color(0xFF225A7C),
          ),
        ),
        title: Text(
          user.nombreUsuario,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${user.correoUsuario}\n${user.cargoUsuario}',
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar') {
              onEdit();
            } else if (value == 'eliminar') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'editar',
              child: Text('Editar'),
            ),
            PopupMenuItem(
              value: 'eliminar',
              child: Text('Eliminar'),
            ),
          ],
        ),
      ),
    );
  }
}