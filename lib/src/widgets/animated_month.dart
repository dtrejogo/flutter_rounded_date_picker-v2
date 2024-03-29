import 'package:flutter/material.dart';

class AnimatedMonth extends StatefulWidget {
  AnimatedMonth({Key? key, required this.child, this.animated = false})
      : super(key: key);

  Widget child;
  bool animated;

  @override
  State<AnimatedMonth> createState() => AnimatedMonthState();
}

class AnimatedMonthState extends State<AnimatedMonth>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 350));

  late Animation<double> sizeAnimation =
      Tween<double>(begin: 1, end: 1.05).animate(_controller);

  @override
  void initState() {
    super.initState();
  }

  startAnimation() {
    _controller.forward().whenComplete(() => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animated) {
      startAnimation();
    }

    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
              scale: sizeAnimation.value, child: widget.child);
        });
  }
}
