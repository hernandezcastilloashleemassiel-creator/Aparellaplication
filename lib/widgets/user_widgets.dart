import 'package:flutter/material.dart';

const Color azulPetroleo = Color(0xFF1F5C7A);
const Color verde = Color(0xFF68C98A);
const Color rojo = Color(0xFFE98585);
const Color bordeRosa = Color(0xFFB8C7E6);

class FormularioUsuario extends StatefulWidget {
  final Future<void> Function(
    String nombre,
    String correo,
    String cargo,
    bool activo,
  ) onGuardar;

  final VoidCallback onCancelar;

  const FormularioUsuario({
    super.key,
    required this.onGuardar,
    required this.onCancelar,
  });

  @override
  State<FormularioUsuario> createState() => _FormularioUsuarioState();
}

class _FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();

  String? _cargo;
  bool _activo = true;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_cargo == null) return;

    setState(() => _guardando = true);

    try {
      await widget.onGuardar(
        _nombreController.text.trim(),
        _correoController.text.trim(),
        _cargo!,
        _activo,
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: azulPetroleo,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Agregar Usuario',
                    style: TextStyle(
                      color: azulPetroleo,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _guardando ? null : widget.onCancelar,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _titulo('Nombre Completo *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nombreController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoracion('Ej: Juan Perez'),
              validator: (value) =>
                  value == null || value.trim().isEmpty
                      ? 'Ingresa el nombre completo'
                      : null,
            ),
            const SizedBox(height: 24),
            _titulo('Cargo *'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _cargo,
              isExpanded: true,
              decoration: _decoracion('Selecciona un cargo'),
              items: const [
                DropdownMenuItem(
                  value: 'Administrador',
                  child: Text('Administrador'),
                ),
                DropdownMenuItem(
                  value: 'Vendedor',
                  child: Text('Vendedor'),
                ),
                DropdownMenuItem(
                  value: 'Cajero',
                  child: Text('Cajero'),
                ),
                DropdownMenuItem(
                  value: 'Encargado de inventario',
                  child: Text('Encargado de inventario'),
                ),
              ],
              onChanged: (value) => setState(() => _cargo = value),
              validator: (value) =>
                  value == null ? 'Selecciona un cargo' : null,
            ),
            const SizedBox(height: 24),
            _titulo('Correo Electrónico *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoracion('Ej: juan@gmail.com'),
              validator: (value) {
                final correo = value?.trim() ?? '';
                if (!correo.contains('@') ||
                    !correo.contains('.') ||
                    correo.isEmpty) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _titulo('Estado *'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _botonEstado(
                    'Activo',
                    _activo,
                    verde,
                    () => setState(() => _activo = true),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _botonEstado(
                    'Inactivo',
                    !_activo,
                    rojo,
                    () => setState(() => _activo = false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulPetroleo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: _guardando
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'GUARDAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        color: azulPetroleo,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _decoracion(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: bordeRosa),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: bordeRosa, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: azulPetroleo, width: 1.5),
      ),
    );
  }

  Widget _botonEstado(
    String texto,
    bool seleccionado,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: seleccionado ? color : Colors.white,
          foregroundColor: seleccionado ? azulPetroleo : color,
          side: BorderSide(color: color, width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}