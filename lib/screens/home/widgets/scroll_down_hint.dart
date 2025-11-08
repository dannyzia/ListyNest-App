import 'package:flutter/material.dart';

class ScrollDownHint extends StatefulWidget {
  @override
  _ScrollDownHintState createState() => _ScrollDownHintState();
}

class _ScrollDownHintState extends State<ScrollDownHint> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Column(
        children: [
          Text('Scroll down to see ads'),
          Icon(Icons.arrow_downward),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
