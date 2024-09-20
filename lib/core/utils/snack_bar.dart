import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

extension Snackbar on BuildContext {
  void showSnackBarFail({required String text, bool? positionTop}) => Flushbar(
    icon: const Icon(
      Icons.error,
      size: 32,
      color: Colors.white,
    ),
    shouldIconPulse: false,
    message: text,
    messageText: Center(
      child: Text(
        text,
        style: Theme.of(this).textTheme.labelMedium,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    ),
    backgroundColor: Colors.red.shade300,
    borderRadius: BorderRadius.circular(16),
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(8),
    flushbarPosition: positionTop == null
        ? FlushbarPosition.BOTTOM
        : FlushbarPosition.TOP,
  )..show(this);

  Future<void> showSnackBarSuccess(
      {required String text,
        bool? positionTop,
        Function(Flushbar flushbar)? ontap}) async {
    final flushbar = Flushbar(
      icon: null,
      shouldIconPulse: false,
      message: text,
      onTap: ontap,
      messageText: Center(
        child: Text(
          text,
          style: Theme.of(this).textTheme.labelMedium,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
      backgroundColor: Colors.green,
      borderRadius: BorderRadius.circular(16),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      flushbarPosition:
      positionTop == null ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP,
    );
    await flushbar.show(this);
  }
}