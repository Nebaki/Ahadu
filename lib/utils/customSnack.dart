import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class snackb extends StatelessWidget {
  final String text;
  snackb(
      {Key? key, required this.text,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: snack(),
    );
  }

  snack() {
    showCustomSnackBar(BuildContext context) => showTopSnackBar(
          context,
           CustomSnackBar.error(
            message: text,
          ),
        );
  }
}
