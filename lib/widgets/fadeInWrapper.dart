import 'package:flutter/material.dart';

class FadeInWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInWrapper({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  _FadeInWrapperState createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
    print('FadeInWrapper: initState - Iniciando fade-in');  // Para depuración
    _controller.forward();  // Fade-in automático
  }

  @override
  void dispose() {
    print('FadeInWrapper: dispose');  // Para depuración
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}