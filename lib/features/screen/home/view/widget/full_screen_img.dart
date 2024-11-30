import 'package:flutter/material.dart';

class FullScreenImg extends StatelessWidget {
  final String imageUrl;

  const FullScreenImg({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 10.0,
          minScale: 1,
          child: ClipRect(
            child: Align(
              alignment: Alignment.center,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Image failed to load',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
