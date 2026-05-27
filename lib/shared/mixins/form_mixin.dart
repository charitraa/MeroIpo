import 'package:flutter/material.dart';

/// Shared form helpers: a [GlobalKey], validation, and snackbars.
///
/// Mix into a `ConsumerStatefulWidget`'s State or a `State`.
mixin FormMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validate() => formKey.currentState?.validate() ?? false;

  void save() => formKey.currentState?.save();

  void showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }
}
