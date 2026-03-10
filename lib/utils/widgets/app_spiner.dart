import 'package:flutter/material.dart';

class AppSpiner extends StatelessWidget {
  const AppSpiner({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(strokeWidth: 2);
  }
}