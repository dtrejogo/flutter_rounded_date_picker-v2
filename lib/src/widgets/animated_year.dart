import 'package:flutter/material.dart';

class AnimatedYear extends StatefulWidget {
  AnimatedYear({Key? key, required this.year, this.animate = true})
      : super(key: key);

  bool animate;

  Text year;

  @override
  State<AnimatedYear> createState() => _AnimatedYearState();
}

class _AnimatedYearState extends State<AnimatedYear>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 350));

  late Animation<double> sizeAnimation =
      Tween<double>(begin: 0, end: 1).animate(_controller);

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _controller.forward().whenComplete(() => _controller
          .reverse()
          .whenComplete(() =>
              _controller.forward().whenComplete(() => _controller.reverse())));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
                color: const Color(0xFF7FB7E2).withOpacity(0.15),
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(color: Colors.transparent, spreadRadius: 2),
                ],
                border: Border.all(
                    width: 1,
                    color: Colors.white.withOpacity(sizeAnimation.value))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              child: widget.year,
            ),
          );
        });
  }
}
