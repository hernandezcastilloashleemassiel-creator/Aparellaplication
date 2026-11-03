
import 'package:flutter/material.dart';

import '../modelo/user_modelo.dart';
import '../core/dependencias.dart';
import '../core/permisos.dart';
import '../service/user_service.dart';
import '../widgets/barra_busq.dart';
import '../widgets/barra_sup.dart';
import '../widgets/widgets_com.dart';
import '../widgets/boton_nav.dart';

class UserScreen extends StatefulWidget {
  final List<String> roles;

  const UserScreen({
    super.key,
    required this.roles,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserServicio servicio = getIt<UserServicio>();

  String busqueda = '';
  bool cargando = true;
  String? error;

  List<User> usuarios = [];

  // VALIDACIÓN DE PERMISOS
  bool get esAdmin =>
      Permisos.esAdministrador(widget.roles);

  @override
  void initState() {
    super.initState();

    // Solamente el administrador consulta usuarios.
    if (esAdmin) {
      _cargar();
    } else {
      cargando = false;
    }
  }

  // CARGAR USUARIOS
  Future<void> _cargar() async {
    if (!esAdmin) return;

    if (mounted) {
      setState(() {
        cargando = true;
        error = null;
      });
    }

    String? mensajeError;
    List<User> resultado = [];

    try {
      resultado = await servicio.listarUsuarios();
    } catch (e) {
      mensajeError =
          e.toString().replaceFirst('Exception: ', '');
    }

    if (!mounted) return;

    setState(() {
      usuarios = resultado;
      error = mensajeError;
      cargando = false;
    });
  }

  // FILTRAR USUARIOS
  List<User> _filtrarUsuarios() {
    final texto = busqueda.toLowerCase().trim();

    if (texto.isEmpty) return usuarios;

    return usuarios.where((usuario) {
      return usuario.nombreUsuario.toLowerCase().contains(texto) ||
          usuario.correoUsuario.toLowerCase().contains(texto) ||
          usuario.cargoUsuario.toLowerCase().contains(texto);
    }).toList();
  }

  // AGREGAR USUARIO
  Future<void> _abrirAgregar() async {
    if (!esAdmin) return;

    final nombreCtrl = TextEditingController();
    final correoCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    String cargoSeleccionado = 'Vendedor';

    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        bool guardando = false;
        String? errorModal;

        return StatefulBuilder(
          builder: (ctx, setModal) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom:
                      MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Agregar usuario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F5C7A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: correoCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: cargoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Cargo',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Administrador',
                          child: Text('Administrador'),
                        ),
                        DropdownMenuItem(
                          value: 'Vendedor',
                          child: Text('Vendedor'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          setModal(() {
                            cargoSeleccionado = valor;
                          });
                        }
                      },
                    ),

                    if (errorModal != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorModal!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1F5C7A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        onPressed: guardando
                            ? null
                            : () async {
                                if (nombreCtrl.text
                                        .trim()
                                        .isEmpty ||
                                    correoCtrl.text
                                        .trim()
                                        .isEmpty ||
                                    passwordCtrl.text.isEmpty) {
                                  setModal(() {
                                    errorModal =
                                        'Completa todos los campos';
                                  });
                                  return;
                                }

                                setModal(() {
                                  guardando = true;
                                  errorModal = null;
                                });

                                try {
                                  await servicio.registrarUsuario(
                                    nombre:
                                        nombreCtrl.text.trim(),
                                    correo:
                                        correoCtrl.text.trim(),
                                    password: passwordCtrl.text,
                                    cargo: cargoSeleccionado,
                                  );

                                  if (ctx.mounted) {
                                    Navigator.pop(ctx, true);
                                  }
                                } catch (e) {
                                  setModal(() {
                                    guardando = false;
                                    errorModal = e
                                        .toString()
                                        .replaceFirst(
                                          'Exception: ',
                                          '',
                                        );
                                  });
                                }
                              },
                        child: Text(
                          guardando
                              ? 'Guardando...'
                              : 'Guardar usuario',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    nombreCtrl.dispose();
    correoCtrl.dispose();
    passwordCtrl.dispose();

    if (guardado == true) {
      await _cargar();
    }
  }

  // EDITAR USUARIO
  Future<void> _editarUsuario(User usuario) async {
    if (!esAdmin) return;

    final nombreCtrl = TextEditingController(
      text: usuario.nombreUsuario,
    );

    final correoCtrl = TextEditingController(
      text: usuario.correoUsuario,
    );

    String cargoSeleccionado =
        usuario.cargoUsuario.toUpperCase() == 'ADMINISTRADOR'
            ? 'Administrador'
            : 'Vendedor';

    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        bool guardando = false;
        String? errorModal;

        return StatefulBuilder(
          builder: (ctx, setModal) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom:
                      MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Editar usuario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F5C7A),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: correoCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      initialValue: cargoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Cargo',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Administrador',
                          child: Text('Administrador'),
                        ),
                        DropdownMenuItem(
                          value: 'Vendedor',
                          child: Text('Vendedor'),
                        ),
                      ],
                      onChanged: (valor) {
                        if (valor != null) {
                          setModal(() {
                            cargoSeleccionado = valor;
                          });
                        }
                      },
                    ),

                    if (errorModal != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorModal!,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF1F5C7A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        onPressed: guardando
                            ? null
                            : () async {
                                if (nombreCtrl.text
                                        .trim()
                                        .isEmpty ||
                                    correoCtrl.text
                                        .trim()
                                        .isEmpty) {
                                  setModal(() {
                                    errorModal =
                                        'Completa todos los campos';
                                  });
                                  return;
                                }

                                setModal(() {
                                  guardando = true;
                                  errorModal = null;
                                });

                                try {
                                  await servicio.actualizarUsuario(
                                    id: usuario.id,
                                    nombre:
                                        nombreCtrl.text.trim(),
                                    correo:
                                        correoCtrl.text.trim(),
                                    cargo: cargoSeleccionado,
                                  );

                                  if (ctx.mounted) {
                                    Navigator.pop(ctx, true);
                                  }
                                } catch (e) {
                                  setModal(() {
                                    guardando = false;
                                    errorModal = e
                                        .toString()
                                        .replaceFirst(
                                          'Exception: ',
                                          '',
                                        );
                                  });
                                }
                              },
                        child: Text(
                          guardando
                              ? 'Guardando...'
                              : 'Guardar cambios',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    nombreCtrl.dispose();
    correoCtrl.dispose();

    if (guardado == true) {
      await _cargar();
    }
  }

  // ELIMINAR USUARIO
  Future<void> _eliminarUsuario(User usuario) async {
    if (!esAdmin) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar usuario'),
          content: Text(
            '¿Deseas eliminar a ${usuario.nombreUsuario}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      await servicio.eliminarUsuario(usuario.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usuario eliminado correctamente',
          ),
        ),
      );

      await _cargar();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  // CONTENIDO DE LA PANTALLA
  Widget _contenido(List<User> lista) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _cargar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (lista.isEmpty) {
      return const EstadoVacio(
        icono: Icons.people_outline,
        mensaje: 'No hay usuarios para mostrar',
      );
    }

    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView.separated(
        itemCount: lista.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final usuario = lista[i];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE1E7ED),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  color: Color(0xFF1F5C7A),
                  size: 36,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.nombreUsuario,
                        style: const TextStyle(
                          color: Color(0xFF1F5C7A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(usuario.correoUsuario),
                      Text(usuario.cargoUsuario),
                    ],
                  ),
                ),

                if (esAdmin) ...[
                  IconButton(
                    tooltip: 'Editar',
                    onPressed: () =>
                        _editarUsuario(usuario),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF1F5C7A),
                    ),
                  ),

                  IconButton(
                    tooltip: 'Eliminar',
                    onPressed: () =>
                        _eliminarUsuario(usuario),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // INTERFAZ PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),

      appBar: const BarraSuperior(
        titulo: 'Usuarios',
        mostrarAtras: false,
      ),

      body: !esAdmin
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 65,
                      color: Color(0xFFD9382B),
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Acceso denegado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F5C7A),
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'No tienes permisos para administrar usuarios.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BarraBusqueda(
                    hint: 'Buscar Usuario...',
                    onChanged: (valor) {
                      setState(() {
                        busqueda = valor;
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: _contenido(
                      _filtrarUsuarios(),
                    ),
                  ),
                ],
              ),
            ),

      // BOTON AGREGAR
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1F5C7A),
              onPressed: _abrirAgregar,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,

      // NAVEGACION
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        roles: widget.roles,
      ),
    );
  }
}
