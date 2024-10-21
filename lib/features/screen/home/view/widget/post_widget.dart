import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_social/core/domain/model/post_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel data;
  final VoidCallback onTap;

  const PostWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the post creation date
    String formattedDate = data.createdAt != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(data.createdAt!)
        : 'Unknown date';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, username, and post time
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  // Placeholder for user avatar
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'), // Add avatar image here
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userId ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Post content
          if (data.postContent != null && data.postContent!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                data.postContent!,
                style: const TextStyle(fontSize: 14),
              ),
            ),

          // Post image (if available)
          if (data.postImage != null && data.postImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                data.postImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Image failed to load');
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      onPressed: () {
                        // Logic for liking a post
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined),
                      onPressed: () {
                        // Logic for commenting on a post
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Logic for sharing a post
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
