import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/cubit/auth/auth_cubit.dart';
import '../../generated/l10n.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL ?? ''),
                radius: 50,
              ),
              SizedBox(height: 20),
              Text(user.displayName ?? ''),
              Text(user.email ?? ''),
            ],
            // Logout Button
            FilledButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
              child: Text(S.of(context).logout),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
