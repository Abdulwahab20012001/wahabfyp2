import 'package:flutter/material.dart';

class mycontainer extends StatelessWidget {
  final Color color;
  final Widget child;
  final double height;
  final double width;
  final double borderRadius;
  const mycontainer({
    super.key,
    required this.color,
    required this.child,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: child,
    );
  }
}
