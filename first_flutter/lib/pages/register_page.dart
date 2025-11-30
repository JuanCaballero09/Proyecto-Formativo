import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:first_flutter/l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

const kOrange = Color.fromRGBO(237, 88, 33, 1);

/// Widget base que replica EXACTAMENTE el fondo / bola / tarjeta del Login.
/// Solo pasas el contenido interno del cuadro blanco como cardChild.
class AuthScaffold extends StatefulWidget {
  final Widget cardChild;
  final bool showBack;
  const AuthScaffold({super.key, required this.cardChild, this.showBack = true});

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Stack(
        children: [
          // Bola grande arriba derecha (decorativa)
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(237, 88, 33, 1), Color(0xFFFFC371)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Botón Atrás
          if (widget.showBack)
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
                          size: 18, 
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context)!.back, 
                          style: TextStyle(
                              fontSize: 16, 
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),

          // Contenedor centrado (card)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SlideTransition(
                position: _slide,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 14, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: widget.cardChild,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Página de Registro que REUSA AuthScaffold para que quede IGUAL al Login.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController apellidoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();
  bool agree = false;
  bool obscure = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    emailCtrl.dispose();
    telefonoCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!agree) {
        _showAuthNotification(
          context,
          message: AppLocalizations.of(context)!.mustAcceptTermsAndConditions,
          isSuccess: false,
        );
        return;
      }

      context.read<AuthBloc>().add(
            RegisterRequested(
              nombre: nombreCtrl.text.trim(),
              apellido: apellidoCtrl.text.trim(),
              email: emailCtrl.text.trim(),
              telefono: telefonoCtrl.text.trim(),
              password: passCtrl.text,
              passwordConfirmation: confirmPassCtrl.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            _showAuthNotification(
              context,
              message: state.message,
              isSuccess: true,
            );
            // Volver al login después del registro exitoso
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted) Navigator.pop(context);
            });
          } else if (state is AuthError) {
            _showAuthNotification(
              context,
              message: state.message,
              isSuccess: false,
            );
          }
        },
        child: AuthScaffold(
          cardChild: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                SizedBox(
                  height: 82,
                  child: Image.asset('assets/logobitevia.png', fit: BoxFit.contain),
                ),
                const SizedBox(height: 8),

                Text(AppLocalizations.of(context)!.createAccountTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    )),
                const SizedBox(height: 20),

                // Nombre
                TextFormField(
                  controller: nombreCtrl,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.firstNameField,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.person_outline, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.firstNameRequiredError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Apellido
                TextFormField(
                  controller: apellidoCtrl,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.lastNameField,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.person_outline, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.lastNameRequiredError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Teléfono
                TextFormField(
                  controller: telefonoCtrl,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneField,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.phone_outlined, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    counterText: '', // Ocultar contador
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.phoneRequiredError;
                    }
                    if (value.trim().length != 10) {
                      return AppLocalizations.of(context)!.phoneMustBe10DigitsError;
                    }
                    if (!value.startsWith('3')) {
                      return AppLocalizations.of(context)!.phoneMustStartWith3Error;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Correo electrónico
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.email_outlined, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppLocalizations.of(context)!.emailRequiredError;
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return AppLocalizations.of(context)!.enterValidEmailError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Contraseña
                TextFormField(
                  controller: passCtrl,
                  obscureText: obscure,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.passwordWithMinimumHint,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.lock_outline, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                        color: kOrange,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.passwordRequiredError;
                    }
                    if (value.length < 6) {
                      return AppLocalizations.of(context)!.minimumSixCharactersError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Confirmación de contraseña
                TextFormField(
                  controller: confirmPassCtrl,
                  obscureText: obscureConfirm,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.confirmPasswordField,
                    labelStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54),
                    prefixIcon: const Icon(Icons.lock_outline, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscureConfirm = !obscureConfirm),
                      icon: Icon(
                        obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        color: kOrange,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.confirmYourPasswordError;
                    }
                    if (value != passCtrl.text) {
                      return AppLocalizations.of(context)!.passwordsDoNotMatchError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Checkbox(
                        value: agree,
                        onChanged: (v) => setState(() => agree = v ?? false),
                        activeColor: kOrange),
                    Expanded(
                        child: Text(AppLocalizations.of(context)!.termsConditions,
                            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color))),
                  ],
                ),

                const SizedBox(height: 8),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOrange,
                          disabledBackgroundColor: kOrange.withValues(alpha: 0.45),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(AppLocalizations.of(context)!.register,
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Vuelve a la pantalla anterior (Login)
                  },
                  child: Text(AppLocalizations.of(context)!.alreadyHaveAccount,
                      style: GoogleFonts.poppins(color: kOrange, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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


