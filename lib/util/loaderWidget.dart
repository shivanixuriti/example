import 'package:flutter/material.dart';

extension LoaderContext on BuildContext {
  void showLoader() {
    showDialog(
        context: this,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
          );
        });
  }

  void hideLoader() {
    Navigator.pop(this);
  }
}
