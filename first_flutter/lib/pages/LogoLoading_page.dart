import 'package:flutter/material.dart';

class LogoloadingPage extends StatefulWidget {
  final double size;

  const LogoloadingPage({Key? key, this.size = 80}) : super(key: key);

  @override
  State<LogoloadingPage> createState() => _LogoloadingPageState();
}

class _LogoloadingPageState extends State<LogoloadingPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // velocidad del "palpitar"
    )..repeat(reverse: true); // repite hacia adelante y hacia atrás

    _animationScale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationScale,
      child: Image.asset(
        'assets/logobitevia.png', // corrige la ruta si es necesario
        width: widget.size,
        height: widget.size,
      ),
    );
  }
}