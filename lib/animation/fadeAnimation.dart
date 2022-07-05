import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(const Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          const Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
        curve: Curves.easeOut)
    ]);


    // return PlayAnimation<double>(
    //   tween: Tween(begin: 50.0, end: 200.0),
    //   duration: const Duration(seconds: 5),
    //   child: // specify child widget
    //   const Center(child: Text('Hello!')),
    //   builder: (context, child, value) {
    //     // obtain child via function parameter
    //     return Container(
    //       width: value,
    //       height: value,
    //       color: Colors.green,
    //       child: child, // place child inside the animation
    //     );
    //   },
    // );
    //
    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: (animation as dynamic)["opacity"] ,
        child: Transform.translate(
          offset: Offset(0, (animation as dynamic)["translateY"]),
          child: child
        ),
      ),
    );
  }
}