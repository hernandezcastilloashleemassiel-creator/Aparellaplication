import 'package:flutter/material.dart';

import '../widgets/boton_nav.dart';
import '../data/user_data.dart';
import '../dependencias.dart';
import '../service/user_service.dart';
import '../widgets/barra_sup.dart';
import '../widgets/boton_nav.dart';
import '../widgets/user_widgets.dart'
    show
        BuscadorUsuarios,
        ErrorUsuarios,
        FormularioUsuario,
        mostrarDetalleUsuario;
import '../widgets/widgets_com.dart' show EstadoVacio, TarjetaItem;

class UserScreen extends StatefulWidget {
  final String token;

  const UserScreen({
    super.key,
    required this.token,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // El servicio lo entrega get_it (se registra en dependencias.dart)
  final UsuarioService servicio = getIt<UsuarioService>();

  List<Usuario> usuarios = [];
  bool cargando = false;
  bool mostrarFormulario = false;
  String busqueda = '';
  String? error;

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    if (widget.token.trim().isEmpty) {
      setState(() {
        error = 'No se recibió el token de inicio de sesión.';
        cargando = false;
      });
      return;
    }

    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado = await servicio.obtenerUsuarios(widget.token);

      if (!mounted) return;

      setState(() {
        usuarios = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceFirst('Exception: ', '');
        cargando = false;
      });
    }
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBDC),
      appBar: BarraSuperior(
        titulo: mostrarFormulario ? 'Nuevo usuario' : 'Gestión de usuarios',
        mostrarAtras: false,
        acciones: mostrarFormulario
            ? null
            : [
                IconButton(
                  onPressed: cargarUsuarios,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'Actualizar',
                ),
              ],
      ),
      body: mostrarFormulario
          ? FormularioUsuario(
              onGuardar: (nombre, correo, cargo) {
                mostrarMensaje(
                  'Formulario completado. '
                  'Falta conectar el guardado a la API.',
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BuscadorUsuarios(
                    onChanged: (texto) => setState(() => busqueda = texto),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _contenidoLista()),
                ],
              ),
            ),
      floatingActionButton: mostrarFormulario
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFF08080),
              foregroundColor: Colors.white,
              onPressed: () => setState(() => mostrarFormulario = false),
              child: const Icon(Icons.arrow_back),
            )
          : FloatingActionButton(
              backgroundColor: const Color(0xFF1F5C7A),
              foregroundColor: Colors.white,
              onPressed: () => setState(() => mostrarFormulario = true),
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 0),
    );
  }

  Widget _contenidoLista() {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1F5C7A)),
      );
    }

    if (error != null) {
      return ErrorUsuarios(mensaje: error!, onReintentar: cargarUsuarios);
    }

    final lista = servicio.filtrar(usuarios, busqueda);

    if (lista.isEmpty) {
      return const EstadoVacio(
        icono: Icons.group_outlined,
        mensaje: 'No se encontraron usuarios',
      );
    }

    return RefreshIndicator(
      onRefresh: cargarUsuarios,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: lista.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final usuario = lista[i];

          return TarjetaItem(
            leading: const Icon(
              Icons.person_outline,
              color: Color(0xFF1F5C7A),
              size: 36,
            ),
            titulo: usuario.nombre.isEmpty ? 'Sin nombre' : usuario.nombre,
            subtitulo: '${usuario.correo}\n${usuario.cargo}',
            etiqueta: usuario.activo ? 'Activo' : 'Inactivo',
            colorEtiqueta: usuario.activo
                ? const Color(0xFF8CE67A)
                : const Color(0xFFF08080),
            onTap: () => mostrarDetalleUsuario(context, usuario),
          );
        },
      ),
    );
  }
}