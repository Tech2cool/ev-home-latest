import 'package:flutter/material.dart';

class SpinningIconBtn extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final void Function() onTap;
  const SpinningIconBtn({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<SpinningIconBtn> createState() => _SpinningIconBtnState();
}

class _SpinningIconBtnState extends State<SpinningIconBtn>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    widget.onTap();
    setState(() {
      _controller?.repeat();
      Future.delayed(Duration(seconds: 3), () {
        _controller?.stop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller!.value * 2.0 * 3.14159, // 2π radians
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          );
        },
      ),
    );
  }
}
