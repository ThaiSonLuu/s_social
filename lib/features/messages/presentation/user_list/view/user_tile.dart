import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final void Function()? onTap;
  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String userName = user['username'] ?? "Unknown";
    final String userEmail = user['email'] ?? "No email";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12)
        ),
        child:  Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 8),
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
