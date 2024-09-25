import 'package:flutter/material.dart';
import 'package:s_social/features/screen/home/model/post_data.dart';
import 'package:s_social/generated/l10n.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String? username;
  bool postAnonymous = false;

  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final fetchedUsername = await PostData.getUserNameFromFirebaseAuth();
    setState(() {
      username = fetchedUsername ?? 'Anonymous';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (username == null)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Posting as: $username'),
                  Switch(
                    value: postAnonymous,
                    onChanged: (value) {
                      setState(() {
                        postAnonymous = value;
                        username = (value ?'Anonymous' : _fetchUsername()) as String?;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: S.of(context).new_post,
                border: const OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newPost = PostData(
                  userName: username ?? 'Anonymous',
                  userImg: 'https://via.placeholder.com/150',
                  content: _contentController.text,
                  postImg: 'https://via.placeholder.com/300',
                  like: 0,
                  cmtNo: 0,
                  share: 0,
                );
                Navigator.pop(context, newPost);
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
