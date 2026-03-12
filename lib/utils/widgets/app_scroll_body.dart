import 'package:flutter/material.dart';

class AppScrollableBody extends StatelessWidget {
  final Widget child;
  final bool centerContent;

  const AppScrollableBody({
    super.key,
    required this.child,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.minHeight,
            ),
            child: centerContent
                ? Center(child: child)
                : child,
          ),
        );
      },
    );
  }
}
