import 'package:adipix/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
// import 'package:adipix/views/auth/register.dart';  // Add for register mode

class AuthShell extends StatefulWidget {
  const AuthShell({Key? key}) : super(key: key);

  @override
  _AuthShellState createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  bool isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    // Move height here if needed: double height = MediaQuery.of(context).size.height;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Padding para el teclado
          ),
          child: Padding(
            padding: const EdgeInsets.all(24), // Completed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Image.asset('assets/img/logo_letras.png',
                    height: height * 0.06),
                const SizedBox(height: 60),
                tileSwitch(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(children: [
                    // Iniciar sesión GestureDetector (unchanged)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLoginMode = true),
                        child: Container(/* unchanged */),
                      ),
                    ),
                    // Registrarme GestureDetector (unchanged)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isLoginMode = false),
                        child: Container(/* unchanged */),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 50),
                // Fixed switcher
                isLoginMode
                    ? LoginScreen(
                        key: const ValueKey('login'),
                        loginMode: true,
                      )
                    : LoginScreen(
                        key: const ValueKey('register'),
                        loginMode: false,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tileSwitch() {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isLoginMode = true),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: isLoginMode ? Colors.white : null,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Text(
                  'Iniciar sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isLoginMode = false),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                  color: !isLoginMode ? Colors.white : null,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: const Text(
                  'Registrarme',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
