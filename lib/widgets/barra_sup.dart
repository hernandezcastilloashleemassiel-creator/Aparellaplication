import 'package:flutter/material.dart';


class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool mostrarAtras;
  final List<Widget>? acciones;

  const BarraSuperior({
    super.key,
    required this.titulo,
    this.mostrarAtras = true,
    this.acciones,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1F5C7A),
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: mostrarAtras
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      ),
      actions: acciones,
    );
  }
}
