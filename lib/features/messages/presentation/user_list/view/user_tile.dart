import 'package:flutter/material.dart';

import '../../../../../core/domain/model/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final void Function()? onTap;
  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            // Avatar
            Icon(Icons.person),
          ],
        ),
      )
    );
  }
}
