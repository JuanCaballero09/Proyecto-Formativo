import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // Degradado de fondo (igual que el Login)
       

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

         
  
          // Botón Atrás (en español)
          if (widget.showBack)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black87),
                      SizedBox(width: 4),
                      Text('Atrás', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ),

          // Contenedor centrado (card) — aquí va el contenido pasado por cardChild
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: SlideTransition(
                position: _slide,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 14, offset: const Offset(0, 8)),
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
/// Solo cambia el contenido interior del cuadro.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool agree = false;
  bool obscure = true;

  InputDecoration fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kOrange),
      prefixIcon: Icon(icon, color: kOrange),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kOrange),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScaffold(
        cardChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo (usa tu asset — asegúrate de que exista)
            // Si tu archivo se llama assets/loogo.jpg manténlo así
            SizedBox(
              height: 82,
              child: Image.asset('assets/loogo.jpg', fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),

            Text('Crear Cuenta',
            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            )),
            // Nombre de usuario
TextField(
  controller: nameCtrl,
  decoration: InputDecoration(
    labelText: 'Nombre de usuario',
    prefixIcon: const Icon(Icons.person_outline, color: kOrange),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
const SizedBox(height: 14),

// Correo electrónico
TextField(
  controller: emailCtrl,
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Correo electrónico',
    prefixIcon: const Icon(Icons.email_outlined, color: kOrange),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
const SizedBox(height: 14),

// Contraseña
TextField(
  controller: passCtrl,
  obscureText: obscure,
  decoration: InputDecoration(
    labelText: 'Contraseña',
    prefixIcon: const Icon(Icons.lock_outline, color: kOrange),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    suffixIcon: IconButton(
      onPressed: () => setState(() => obscure = !obscure),
      icon: Icon(
        obscure ? Icons.visibility : Icons.visibility_off,
        color: kOrange,
      ),
    ),
  ),
),
const SizedBox(height: 14),

            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(value: agree, onChanged: (v) => setState(() => agree = v ?? false), activeColor: kOrange),
                const Expanded(child: Text('Acepto los Términos y Condiciones', style: TextStyle(fontSize: 13))),
              ],
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: agree ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  disabledBackgroundColor: kOrange.withOpacity(0.45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: Text('Registrarse', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 12),
            Text('O regístrate con tus redes', style: GoogleFonts.poppins(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(Icons.facebook, color: Colors.blue, size: 30),
              SizedBox(width: 18),
              Icon(Icons.alternate_email, color: Colors.lightBlue, size: 30),
            ]),

            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('¿Ya tienes una cuenta? Inicia sesión', style: GoogleFonts.poppins(color: kOrange, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}