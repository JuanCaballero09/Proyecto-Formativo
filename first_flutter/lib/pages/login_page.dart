import 'package:first_flutter/pages/register_page.dart';
import 'package:first_flutter/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import 'product_catalog_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  String errorMessage = '';

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const kOrange = Color.fromRGBO(237, 88, 33, 1);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
            begin: const Offset(0, .2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _togglePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);

  Future<void> _login() async {
    final user = userController.text.trim();
    final pass = passController.text.trim();
    if (user.isEmpty || pass.isEmpty) {
      setState(() => errorMessage = 'Por favor ingresa usuario y contraseña');
      return;
    }
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    
    final api = ApiService();
    final userData = await api.login(user, pass);
    
    if (!mounted) return;

    // ✅ Mostrar popup en el centro
    if (userData != null) {
    showDialog(
      context: context,
      barrierDismissible: false, // no se cierra tocando afuera
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  "Inicio de sesión exitoso",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );

    // ⏳ Esperar 1.5 seg y navegar
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // cierra el dialog
      
      // Disparar evento con datos del usuario
      final fullName = '${userData['nombre'] ?? ''} ${userData['apellido'] ?? ''}'.trim();
      context.read<AuthBloc>().add(
        LoginRequested(user, pass, userName: fullName.isEmpty ? 'Usuario' : fullName)
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProductCatalogPage()),
      );
    });
    } else {
      setState(() => errorMessage = 'Credenciales inválidas');
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Círculo degradado superior derecho
            Positioned(
              top: -120,
              right: -120,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [kOrange, Color(0xFFFFC371)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Back "Atrás"
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: Colors.black87),
                      SizedBox(width: 4),
                      Text('Atrás',
                          style:
                              TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),

            // Cuadro blanco con sombra (formulario)
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 460),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset('assets/loogo.jpg', height: 90),
                        const SizedBox(height: 16),

                        // Títulos
                        Text('¡Hola!',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            )),
                        Text('Inicia sesión en tu cuenta',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black54,
                            )),
                        const SizedBox(height: 22),

                        // Email
                        TextField(
                          controller: userController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon:
                                const Icon(Icons.email_outlined, color: kOrange),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password
                        TextField(
                          controller: passController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon:
                                const Icon(Icons.lock_outline, color: kOrange),
                            suffixIcon: IconButton(
                              onPressed: _togglePassword,
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kOrange,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('¿Olvidaste tu contraseña?',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: kOrange)),
                        ),
                        const SizedBox(height: 18),

                        // Botón ingresar
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Ingresar',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 18),
                        Text('O ingresa con tus redes sociales',
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.facebook, color: Colors.blue, size: 32),
                            SizedBox(width: 26),
                            Icon(Icons.alternate_email,
                                color: Colors.lightBlue, size: 32),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¿No tienes una cuenta?',
                                style: GoogleFonts.poppins(fontSize: 14)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterPage()),
                                );
                              },
                              child: const Text('Regístrate aquí',
                                  style: TextStyle(
                                      color: kOrange,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),

                        if (errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red)),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
