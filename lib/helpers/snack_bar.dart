import 'package:flutter/material.dart';

class Snackbar {
  void showSnack(BuildContext context, String message, GlobalKey<ScaffoldState> scaffoldKey, VoidCallback? undo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: undo != null
            ? SnackBarAction(
          textColor: Theme.of(context).primaryColor,
          label: "Undo",
          onPressed: undo,
        )
            : null,
      ),
    );
  }
}