import 'package:flutter/material.dart';
import '../service/login_service.dart';
import '../core/dependencias.dart';
import 'dashboard_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  final _authService = getIt<AuthService>();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(error)),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F3),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // LOGO
                  const Text(
                    'Apparel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3A4D),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Bienvenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3A4D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Inicia sesión para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5F6F7A),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // CORREO
                  buildLabel('Correo electrónico'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(
                      hint: '@correo.com',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      final correo = value?.trim() ?? '';

                      if (correo.isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      // El @ es obligatorio
                      if (!correo.contains('@')) {
                        return 'El correo debe tener @';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // CONTRASEÑA
                  buildLabel('Contraseña'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: inputDecoration(
                      hint: 'Ingresa tu contraseña',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF5C6BC0),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      final password = value ?? '';
                      if (password.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // BOTÓN LOGIN
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5F8A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
          width: 24,
         height: 24,
         child: CircularProgressIndicator(
          color: Colors.white,
         strokeWidth: 2.5,
            ),
         )
         : const Text(
        'Iniciar sesión',
          style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
                               ),
                 ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1F3A4D),
    ),
  );
}

InputDecoration inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
    prefixIcon: Icon(
      icon,
      color: const Color(0xFF5C6BC0),
    ),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: const Color(0xFFF8F6EE),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFE8E4D8),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFE8E4D8),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF5C6BC0),
        width: 1.6,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFF87171),
        width: 1.4,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFF87171),
        width: 1.6,
      ),
    ),
  );
}