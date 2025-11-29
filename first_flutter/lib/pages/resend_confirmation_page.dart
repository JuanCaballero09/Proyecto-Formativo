import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'register_page.dart'; // Para reutilizar AuthScaffold

const kOrange = Color.fromRGBO(237, 88, 33, 1);

class ResendConfirmationPage extends StatefulWidget {
  const ResendConfirmationPage({super.key});

  @override
  State<ResendConfirmationPage> createState() => _ResendConfirmationPageState();
}

class _ResendConfirmationPageState extends State<ResendConfirmationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _handleResendConfirmation() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ResendConfirmationRequested(email: emailCtrl.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ConfirmationEmailSent) {
            _showAuthNotification(
              context,
              message: state.message,
              isSuccess: true,
            );
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
                  child: Image.asset('assets/loogo.jpg', fit: BoxFit.contain),
                ),
                const SizedBox(height: 8),

                Text(
                  'Reenviar Confirmación',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Ingresa tu correo electrónico y te reenviaremos el enlace de confirmación.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // Email
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    labelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white70 
                          : Colors.black54
                    ),
                    prefixIcon: const Icon(Icons.email_outlined, color: kOrange),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[800] 
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.grey.shade700 
                            : Colors.grey.shade300
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kOrange),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El email es requerido';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Ingresa un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleResendConfirmation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kOrange,
                          disabledBackgroundColor: kOrange.withValues(alpha: 0.45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
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
                            : Text(
                                'Reenviar',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Volver al inicio de sesión',
                    style: GoogleFonts.poppins(
                      color: kOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
