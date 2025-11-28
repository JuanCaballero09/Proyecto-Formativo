import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../bloc/connection/connection_cubit.dart';
import '../bloc/connection/connection_state.dart';
import '../service/api_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late ConnectionCubit _connectionCubit;

  @override
  void initState() {
    super.initState();

    _connectionCubit = ConnectionCubit(apiService: ApiService());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    // Iniciar verificación de conexión
    _connectionCubit.checkConnection();
  }

  @override
  void dispose() {
    _controller.dispose();
    _connectionCubit.close();
    super.dispose();
  }

  void _navigateToHome() async {
    if (mounted) {
      await Navigator.pushReplacementNamed(context, '/home');
      // El cubit se cerrará en dispose cuando se desmonte este widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
      body: BlocConsumer<ConnectionCubit, ServerConnectionState>(
        bloc: _connectionCubit,
        listener: (context, state) {
          if (state is ConnectionSuccess) {
            // Esperar 1.5s después de conexión exitosa antes de navegar
            Future.delayed(const Duration(milliseconds: 1500), _navigateToHome);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Contenido principal centrado
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/LogoTextNoFondo.png',
                            width: 160,
                            height: 160,
                          ),
                          const SizedBox(height: 30),
                          
                          // Indicador de estado de conexión
                          _buildConnectionIndicator(state),
                          
                          const SizedBox(height: 20),
                          
                          // Mensaje de estado
                          _buildStatusMessage(state),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Versión siempre en la parte inferior
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Text(
                  'v4.3.3',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConnectionIndicator(ServerConnectionState state) {
    if (state is ConnectionChecking) {
      return LoadingAnimationWidget.progressiveDots(
        color: Colors.white,
        size: 50,
      );
    } else if (state is ConnectionSuccess) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
          );
        },
      );
    } else if (state is ConnectionError) {
      return Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              state.isCritical ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 30),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _connectionCubit.retry(),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Color.fromRGBO(237, 88, 33, 1),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Reintentar',
                      style: GoogleFonts.quicksand(
                        textStyle: const TextStyle(
                          color: Color.fromRGBO(237, 88, 33, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatusMessage(ServerConnectionState state) {
    String message = 'Tus antojos los verás pronto...';
    Color color = Colors.white;
    FontWeight fontWeight = FontWeight.w400;

    if (state is ConnectionChecking) {
      message = 'Conectando con el servidor...';
      fontWeight = FontWeight.w500;
    } else if (state is ConnectionSuccess) {
      message = '¡Conexión establecida!';
      fontWeight = FontWeight.w600;
    } else if (state is ConnectionError) {
      message = state.friendlyMessage;
      color = Colors.white;
      fontWeight = FontWeight.w500;
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Text(
          message,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: fontWeight,
              letterSpacing: 0.2,
              height: 1.5,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
    );
  }
}
