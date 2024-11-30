import 'dart:async';

import 'package:flutter/material.dart';

extension ShowLoadingDialog on BuildContext {
  Future<T> showDialogLoading<T>({
    required Future<T> Function() future,
    bool barrierDismissible = false,
  }) async {
    BuildContext? popContext;
    unawaited(
      showDialog(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: (dialogContext) {
          popContext = dialogContext;
          return const DialogLoading();
        },
      ),
    );

    try {
      final result = await future();
      return result;
    } finally {
      if (popContext != null && popContext!.mounted) {
        Navigator.of(popContext!).pop();
      }
    }
  }
}

class DialogLoading extends StatelessWidget {
  const DialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Wrap(
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.4)
                    .withAlpha(200),
              ),
              child: const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
