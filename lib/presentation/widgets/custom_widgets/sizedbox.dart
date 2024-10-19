import 'package:flutter/material.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_appbar.dart';

SizedBox VerSizedBox(double size) {
  return SizedBox(
    height: size,
  );
}

SizedBox HorSizedBox(double size) {
  return SizedBox(
    width: size,
  );
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.basicAppBar(context),
    );
  }
}
