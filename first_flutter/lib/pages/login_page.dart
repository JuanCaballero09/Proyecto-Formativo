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
      _showAuthNotification(
        context,
        message: 'Por favor ingresa usuario y contraseña',
        isSuccess: false,
      );
      return;
    }
    
    // Validar formato de correo electrónico
    if (!user.contains('@') || !user.contains('.')) {
      _showAuthNotification(
        context,
        message: 'Por favor ingresa un correo electrónico válido',
        isSuccess: false,
      );
      return;
    }
    
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    
    final api = ApiService();
    final response = await api.login(user, pass);
    
    if (!mounted) return;

    setState(() => isLoading = false);

    // ✅ Verificar si el login fue exitoso
    if (response['success'] == true) {
      final userData = response['user'];
      
      // Mostrar popup de éxito
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "¡Inicio de sesión exitoso!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Bienvenido de nuevo",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      // ⏳ Esperar y navegar
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
      // ❌ Mostrar error con isla dinámica
      _showAuthNotification(
        context,
        message: response['message'] ?? 'Error al iniciar sesión',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,
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
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: isDark ? Colors.white : Colors.black87),
                      const SizedBox(width: 4),
                      Text('Atrás',
                          style:
                              TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black54 : Colors.black26,
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        Image.asset('assets/logobitevia.png', height: 90),
                        const SizedBox(height: 16),

                        // Títulos
                        Text('¡Bienvenido!',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            )),
                        Text('Inicia sesión en tu cuenta',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                            )),
                        const SizedBox(height: 22),

                        // Email
                        TextField(
                          controller: userController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                            prefixIcon:
                                const Icon(Icons.email_outlined, color: kOrange),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[800] 
                                : Colors.white,
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
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
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
                            fillColor: Theme.of(context).brightness == Brightness.dark 
                                ? Colors.grey[800] 
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/resend-confirmation');
                              },
                              child: Text('Reenviar confirmación',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, 
                                      color: kOrange,
                                      fontWeight: FontWeight.w600)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/forgot-password');
                              },
                              child: Text('¿Olvidaste tu contraseña?',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, 
                                      color: kOrange,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

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
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ),
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

  void _showAuthNotification(BuildContext context, {required String message, required bool isSuccess}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSuccess
                      ? [const Color(0xFF4CAF50), const Color(0xFF45A049)]
                      : [const Color(0xFFEF5350), const Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: (isSuccess ? const Color(0xFF4CAF50) : const Color(0xFFEF5350))
                        .withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 3000), () {
      overlayEntry.remove();
    });
  }
}
