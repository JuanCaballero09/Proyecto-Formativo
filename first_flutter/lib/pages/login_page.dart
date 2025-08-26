import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'inter_page.dart'; // Tu página principal con el menú
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String errorMessage = '';
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _userFieldTouched = false;
  bool _passFieldTouched = false;
  
  late AnimationController _fadeController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shakeController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // Validaciones mejoradas
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _showErrorAnimation() {
    _shakeController.forward().then((_) {
      _shakeController.reset();
    });
  }

  void _login() async {
    setState(() {
      _userFieldTouched = true;
      _passFieldTouched = true;
      errorMessage = '';
    });

    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      _showErrorAnimation();
      return;
    }

    setState(() {
      isLoading = true;
    });

    final user = _userController.text.trim();
    final pass = _passController.text;

    try {
      if (!mounted) return;

      await Future.delayed(const Duration(seconds: 2)); // Simula carga

      if (!mounted) return;

      // Lógica de autenticación mejorada
      if (user.toLowerCase() == 'admin@terraza.com' && pass == '123456') {
        // Login exitoso
        setState(() => isLoading = false);
        if (!mounted) return;
        
        // Animación de éxito antes de navegar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('¡Bienvenido!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProductPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      } else {
        throw Exception('Credenciales incorrectas');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        if (e.toString().contains('Credenciales incorrectas')) {
          errorMessage = 'Usuario o contraseña incorrectos';
        } else {
          errorMessage = 'Error de conexión. Inténtalo de nuevo.';
        }
      });
      _showErrorAnimation();
      
      // Mostrar feedback visual adicional
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Regresar',
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading ? _buildLoadingWidget() : _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 800),
          child: Text(
            'Tus antojos los verás pronto...',
            style: GoogleFonts.quicksand(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shake = _shakeAnimation.value * 10 * 
                     (1 - _shakeAnimation.value);
        return Transform.translate(
          offset: Offset(shake, 0),
          child: Form(
            key: _formKey,
            child: Column(
              key: const ValueKey('login_form'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título con animación
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                  )),
                  child: Text(
                    'Iniciar Sesión',
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    semanticsLabel: 'Página de inicio de sesión',
                  ),
                ),
                const SizedBox(height: 40),

                // Campo de email con validación
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                  )),
                  child: Semantics(
                    label: 'Campo de correo electrónico',
                    child: TextFormField(
                      controller: _userController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: _validateEmail,
                      autovalidateMode: _userFieldTouched 
                          ? AutovalidateMode.onUserInteraction 
                          : AutovalidateMode.disabled,
                      onChanged: (value) {
                        if (!_userFieldTouched) {
                          setState(() => _userFieldTouched = true);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'ejemplo@correo.com',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.email_outlined, 
                                             color: Color.fromRGBO(237, 88, 33, 1)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(237, 88, 33, 1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de contraseña con mostrar/ocultar
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
                  )),
                  child: Semantics(
                    label: 'Campo de contraseña',
                    child: TextFormField(
                      controller: _passController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: _validatePassword,
                      autovalidateMode: _passFieldTouched 
                          ? AutovalidateMode.onUserInteraction 
                          : AutovalidateMode.disabled,
                      onChanged: (value) {
                        if (!_passFieldTouched) {
                          setState(() => _passFieldTouched = true);
                        }
                      },
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.lock_outline, 
                                             color: Color.fromRGBO(237, 88, 33, 1)),
                        suffixIcon: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              key: ValueKey(_obscurePassword),
                              color: const Color.fromRGBO(237, 88, 33, 1),
                            ),
                          ),
                          onPressed: _togglePasswordVisibility,
                          tooltip: _obscurePassword ? 'Mostrar contraseña' : 'Ocultar contraseña',
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(237, 88, 33, 1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botón de login con animación
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
                  )),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromRGBO(237, 88, 33, 1),
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          'Entrar',
                          key: const ValueKey('login_button_text'),
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Link de contraseña olvidada
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.9, 1.0, curve: Curves.easeOut),
                  )),
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Funcionalidad próximamente disponible'),
                          backgroundColor: Colors.blue,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Mensaje de error animado
                if (errorMessage.isNotEmpty)
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _shakeController,
                      curve: Curves.elasticOut,
                    )),
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),
                
                // Información de credenciales de prueba
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'Credenciales de prueba:',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: admin@terraza.com\nContraseña: 123456',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

