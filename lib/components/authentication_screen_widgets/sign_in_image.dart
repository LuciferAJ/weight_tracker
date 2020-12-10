import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/shared/ui_helpers.dart';

class CustomAnimatedLogo extends StatefulWidget {
  @override
  _CustomAnimatedLogoState createState() => _CustomAnimatedLogoState();
}

class _CustomAnimatedLogoState extends State<CustomAnimatedLogo>
    with TickerProviderStateMixin {
  Animation<double> logoAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    logoAnimation = new CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(AssetImage('assets/images/weight.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: screenHeight(context) * 0.3,
        width: screenHeight(context) * 0.3,
        child: Center(
          child: Container(
            child: new ScaleTransition(
              scale: logoAnimation,
              child: new Container(
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/weight.png')),
                    shape: BoxShape.circle),
                height: screenWidth(context) * 0.5,
                width: screenWidth(context) * 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
