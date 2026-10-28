
import 'package:flutter/material.dart';
import '../widgets/boton_nav.dart';
import '../data/user_data.dart';
import '../service/user_service.dart';
import '../widgets/user_widgets.dart';

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
  late final UsuarioService servicio;

  List<Usuario> usuarios = [];
  bool cargando = false;
  bool mostrarFormulario = false;
  String busqueda = '';
  String? error;

  @override
  void initState() {
    super.initState();

    // Para el emulador Android de Android Studio.
    const String baseUrl = 'https://10.0.2.2:7180';

    servicio = UsuarioService(
      UsuarioData(baseUrl),
    );

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
      final resultado =
          await servicio.obtenerUsuarios(widget.token);

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

  List<Usuario> get usuariosFiltrados {
    final texto = busqueda.toLowerCase().trim();

    return usuarios.where((usuario) {
      return usuario.nombre.toLowerCase().contains(texto) ||
          usuario.correo.toLowerCase().contains(texto) ||
          usuario.cargo.toLowerCase().contains(texto);
    }).toList();
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  void mostrarDetalles(Usuario usuario) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(usuario.nombre),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Correo: ${usuario.correo}'),
            const SizedBox(height: 8),
            Text('Cargo: ${usuario.cargo}'),
            const SizedBox(height: 8),
            Text(
              'Estado: ${usuario.activo ? 'Activo' : 'Inactivo'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),
      appBar: AppBar(
        backgroundColor: azulPetroleo,
        foregroundColor: Colors.white,
        title: Text(
          mostrarFormulario
              ? 'Nuevo usuario'
              : 'Gestión de usuarios',
        ),
        actions: [
          if (!mostrarFormulario)
            IconButton(
              onPressed: cargarUsuarios,
              icon: const Icon(Icons.refresh),
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
                    onChanged: (texto) {
                      setState(() => busqueda = texto);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _contenidoLista(),
                  ),
                ],
              ),
            ),
      floatingActionButton: mostrarFormulario
          ? FloatingActionButton(
              backgroundColor: rojo,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() => mostrarFormulario = false);
              },
              child: const Icon(Icons.arrow_back),
            )
          : FloatingActionButton(
              backgroundColor: verde,
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() => mostrarFormulario = true);
              },
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar:
          const CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _contenidoLista() {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(
          color: azulPetroleo,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: rojo,
                size: 45,
              ),
              const SizedBox(height: 12),
              Text(
                error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cargarUsuarios,
                child: const Text('Intentar de nuevo'),
              ),
            ],
          ),
        ),
      );
    }

    final lista = usuariosFiltrados;

    if (lista.isEmpty) {
      return const Center(
        child: Text('No se encontraron usuarios.'),
      );
    }

    return RefreshIndicator(
      onRefresh: cargarUsuarios,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final usuario = lista[index];

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: bordeRosa),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: beige,
                child: const Icon(
                  Icons.person,
                  color: azulPetroleo,
                ),
              ),
              title: Text(
                usuario.nombre.isEmpty
                    ? 'Sin nombre'
                    : usuario.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${usuario.correo}\n${usuario.cargo}',
              ),
              isThreeLine: true,
              trailing: Icon(
                usuario.activo
                    ? Icons.check_circle
                    : Icons.cancel,
                color: usuario.activo ? verde : rojo,
              ),
              onTap: () => mostrarDetalles(usuario),
            ),
          );
        },
      ),
    );
  }
}
