import 'package:flutter/material.dart';

import '../data/user_data.dart';

// Colores que usaba antes boton_nav.dart. Si los tuyos eran otros, cámbialos aquí.
const beige = Color(0xFFF2EBDC);
const azulPetroleo = Color(0xFF1F5C7A);
const verde = Color(0xFF8CE67A);
const rojo = Color(0xFFF08080);
const bordeRosa = Color(0xFFE8D5D5);

// ---------------------------------------------------------------
// BUSCADOR
// ---------------------------------------------------------------
class BuscadorUsuarios extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BuscadorUsuarios({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB8C7E6), width: 2),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
          color: Color(0xFF1F5C7A),
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          hintText: 'Buscar Usuario...',
          hintStyle: TextStyle(
            color: Color(0xFF1F5C7A),
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(Icons.search, color: Color(0xFF3F6FD1)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// FORMULARIO DE NUEVO USUARIO
// ---------------------------------------------------------------
class FormularioUsuario extends StatefulWidget {
  final void Function(String nombre, String correo, String cargo) onGuardar;

  const FormularioUsuario({super.key, required this.onGuardar});

  @override
  State<FormularioUsuario> createState() => _FormularioUsuarioState();
}

class _FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _cargoCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _cargoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    widget.onGuardar(
      _nombreCtrl.text.trim(),
      _correoCtrl.text.trim(),
      _cargoCtrl.text.trim(),
    );
  }

  InputDecoration _decoracion(String hint, IconData icono) {
    OutlineInputBorder borde(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        );

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icono, color: const Color(0xFF3F6FD1)),
      filled: true,
      fillColor: Colors.white,
      border: borde(const Color(0xFFB8C7E6)),
      enabledBorder: borde(const Color(0xFFB8C7E6)),
      focusedBorder: borde(const Color(0xFF1F5C7A)),
      errorBorder: borde(const Color(0xFFE53935)),
      focusedErrorBorder: borde(const Color(0xFFE53935)),
    );
  }

  Widget _campo({
    required String etiqueta,
    required String hint,
    required TextEditingController controller,
    required IconData icono,
    required String? Function(String?) validator,
    TextInputType teclado = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: Color(0xFF1F5C7A),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: teclado,
          validator: validator,
          decoration: _decoracion(hint, icono),
        ),
      ],
    );
  }

  String? _obligatorio(String? v, String mensaje) =>
      (v == null || v.trim().isEmpty) ? mensaje : null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _campo(
              etiqueta: 'Nombre',
              hint: 'Nombre completo',
              controller: _nombreCtrl,
              icono: Icons.person_outline,
              validator: (v) => _obligatorio(v, 'Ingresa el nombre'),
            ),
            const SizedBox(height: 16),
            _campo(
              etiqueta: 'Correo electrónico',
              hint: '@correo.com',
              controller: _correoCtrl,
              icono: Icons.email_outlined,
              teclado: TextInputType.emailAddress,
              validator: (v) {
                final correo = v?.trim() ?? '';
                if (correo.isEmpty) return 'Ingresa el correo';
                if (!correo.contains('@')) return 'El correo debe tener @';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _campo(
              etiqueta: 'Cargo',
              hint: 'Ej: Vendedor',
              controller: _cargoCtrl,
              icono: Icons.badge_outlined,
              validator: (v) => _obligatorio(v, 'Ingresa el cargo'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F5C7A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Guardar',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// MENSAJE DE ERROR (con botón para reintentar)
// ---------------------------------------------------------------
class ErrorUsuarios extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const ErrorUsuarios({
    super.key,
    required this.mensaje,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFF08080),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1F5C7A),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F5C7A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// DETALLE DEL USUARIO (diálogo)
// ---------------------------------------------------------------
void mostrarDetalleUsuario(BuildContext context, Usuario usuario) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(usuario.nombre),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Correo: ${usuario.correo}'),
          const SizedBox(height: 8),
          Text('Cargo: ${usuario.cargo}'),
          const SizedBox(height: 8),
          Text('Estado: ${usuario.activo ? 'Activo' : 'Inactivo'}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}