import 'package:flutter/material.dart';

const Color azulPetroleo = Color(0xFF206582);
const Color beige = Color(0xFFF5EEDC);
const Color verde = Color(0xFF68C98A);
const Color rojo = Color(0xFFE98585);
const Color bordeRosa = Color(0xFFF1BABA);

class BuscadorUsuarios extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BuscadorUsuarios({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o correo',
        prefixIcon: const Icon(Icons.search, color: azulPetroleo),
        filled: true,
        fillColor: beige,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bordeRosa),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bordeRosa),
        ),
      ),
    );
  }
}

class FormularioUsuario extends StatefulWidget {
  final void Function(String nombre, String correo, String cargo)
      onGuardar;

  const FormularioUsuario({
    super.key,
    required this.onGuardar,
  });

  @override
  State<FormularioUsuario> createState() => _FormularioUsuarioState();
}

class _FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _cargoController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Agregar usuario',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: azulPetroleo,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresá el nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Ingresá un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cargoController,
              decoration: const InputDecoration(
                labelText: 'Cargo o rol',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresá el cargo';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: azulPetroleo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onGuardar(
                    _nombreController.text.trim(),
                    _correoController.text.trim(),
                    _cargoController.text.trim(),
                  );
                }
              },
              child: const Text('Guardar usuario'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}