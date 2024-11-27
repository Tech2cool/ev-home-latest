import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class NavratriOfferPopup extends StatefulWidget {
  const NavratriOfferPopup({super.key});

  @override
  _NavratriOfferPopupState createState() => _NavratriOfferPopupState();
}

class _NavratriOfferPopupState extends State<NavratriOfferPopup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.orange[400],
      end: Colors.pink[400],
    ).animate(_colorController);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (_colorAnimation.value ?? Colors.orange[400])!
                        .withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildImage(),
              const SizedBox(height: 20),
              _buildOfferDescription(),
              const SizedBox(height: 20),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [Colors.orange, Colors.pink, Colors.purple],
          stops: [0.0, 0.5, 1.0],
          tileMode: TileMode.clamp,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: const Text(
        'Navratri Special Offer',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 225,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/navratri.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [
                    0.0,
                    _shimmerController.value,
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOfferDescription() {
    return Column(
      children: [
        Text(
          'Celebrate the spirit of Navratri!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Get up to 30% off on selected properties',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Text(
              'Limited time offer - Book now!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _colorAnimation.value,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text(
        'Claim Offer',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
