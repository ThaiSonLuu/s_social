import 'package:flutter/material.dart';

import '../../../../../core/domain/model/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final void Function()? onTap;
  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String userName = user.username ?? "Unknown";
    final String userEmail = user.email ?? "No email";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12)
        ),
        child:  Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 8),
            // User information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                ),
                Text(
                  userEmail,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
