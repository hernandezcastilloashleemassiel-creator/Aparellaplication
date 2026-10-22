import 'package:flutter/material.dart';
import '../../widgets/barra_busq.dart';
import '../../widgets/barra_sup.dart';
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
  bool cargando = true;
  bool mostrarFormulario = false;
  String busqueda = '';
  String filtroCargo = 'Todos';
  String? error;

  @override
  void initState() {
    super.initState();

    const baseUrl = 'http://10.0.2.2:5294';
    servicio = UsuarioService(UsuarioData(baseUrl));
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    if (widget.token.trim().isEmpty) {
      setState(() {
        cargando = false;
        error = 'No se encontró el token de sesión.';
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
        cargando = false;
        error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  List<Usuario> get usuariosFiltrados {
    return usuarios.where((usuario) {
      final texto = busqueda.toLowerCase();

      final coincideBusqueda =
          usuario.nombre.toLowerCase().contains(texto) ||
          usuario.correo.toLowerCase().contains(texto) ||
          usuario.cargo.toLowerCase().contains(texto);

      final coincideCargo = filtroCargo == 'Todos' ||
          usuario.cargo.toLowerCase() == filtroCargo.toLowerCase();

      return coincideBusqueda && coincideCargo;
    }).toList();
  }

  Future<void> guardarUsuario(
    String nombre,
    String correo,
    String cargo,
    bool activo,
  ) async {
    try {
      await servicio.crearUsuario(
        token: widget.token,
        nombre: nombre,
        correo: correo,
        cargo: cargo,
        activo: activo,
      );

      if (!mounted) return;

      setState(() => mostrarFormulario = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado correctamente.')),
      );

      await cargarUsuarios();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BarraSuperior(
        titulo: 'USUARIOS',
        mostrarAtras: true,
        acciones: [
          if (!mostrarFormulario)
            IconButton(
              onPressed: cargarUsuarios,
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualizar',
            ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: mostrarFormulario
              ? SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: FormularioUsuario(
                    onGuardar: guardarUsuario,
                    onCancelar: () {
                      setState(() => mostrarFormulario = false);
                    },
                  ),
                )
              : _construirLista(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1F5C7A),
        foregroundColor: Colors.white,
        onPressed: () {
          setState(() => mostrarFormulario = !mostrarFormulario);
        },
        child: Icon(
          mostrarFormulario ? Icons.close : Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
    );
  }

  Widget _construirLista() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: BarraBusqueda(
            hint: 'Buscar Usuario...',
            onChanged: (valor) {
              setState(() => busqueda = valor);
            },
            onFiltro: _mostrarFiltros,
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filtro('Todos'),
              _filtro('Administrador'),
              _filtro('Vendedor'),
              _filtro('Cajero'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _contenidoUsuarios()),
      ],
    );
  }

  void _mostrarFiltros() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por cargo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F5C7A),
                  ),
                ),
                const SizedBox(height: 12),
                for (final cargo in [
                  'Todos',
                  'Administrador',
                  'Vendedor',
                  'Cajero',
                  'Encargado de inventario',
                ])
                  ListTile(
                    title: Text(cargo),
                    trailing: filtroCargo == cargo
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFF1F5C7A),
                          )
                        : null,
                    onTap: () {
                      setState(() => filtroCargo = cargo);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filtro(String cargo) {
    final seleccionado = filtroCargo == cargo;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(cargo),
        selected: seleccionado,
        selectedColor: const Color(0xFF1F5C7A),
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: seleccionado ? Colors.white : const Color(0xFF1F5C7A),
        ),
        onSelected: (_) {
          setState(() => filtroCargo = cargo);
        },
      ),
    );
  }

  Widget _contenidoUsuarios() {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1F5C7A),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 12),
              const Text(
                'No se pudieron cargar los usuarios.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: cargarUsuarios,
                child: const Text('Intentar nuevamente'),
              ),
            ],
          ),
        ),
      );
    }

    final lista = usuariosFiltrados;

    if (lista.isEmpty) {
      return Center(
        child: Text(
          usuarios.isEmpty
              ? 'No hay usuarios registrados.'
              : 'No se encontraron usuarios.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cargarUsuarios,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
        itemCount: lista.length,
        itemBuilder: (context, index) {
          final usuario = lista[index];

          return Card(
            color: Colors.white,
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: Color(0xFFB8C7E6)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF1F5C7A),
                    child: Text(
                      usuario.nombre.isEmpty
                          ? '?'
                          : usuario.nombre[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario.nombre,
                          style: const TextStyle(
                            color: Color(0xFF1F5C7A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          usuario.correo,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(usuario.cargo),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    usuario.activo ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: usuario.activo
                          ? const Color(0xFF268653)
                          : const Color(0xFFD84B4B),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}