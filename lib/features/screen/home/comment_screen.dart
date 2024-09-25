import 'package:flutter/material.dart';
import 'package:s_social/features/screen/home/model/post_data.dart';

class CommentScreen extends StatefulWidget {
  final PostData data;
  final int postId;


  CommentScreen({
    required this.data,
    required this.postId
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _cmtCtrl = TextEditingController();
  final List<String> comments = [];

  void _addComment() {
    String newComment = _cmtCtrl.text.trim();
    if (newComment.isNotEmpty) {
      setState(() {
      comments.add(newComment);
      });
      _cmtCtrl.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    final imgWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        title: Text('Comments on Post ${widget.postId}'),
      ),
      body: Column(
        children: [
          // Thông tin bài viết
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(widget.data.userName),
                  subtitle: Text(widget.data.content),
                ),
                widget.data.postImg.isNotEmpty
                    ? Image.network(
                  widget.data.postImg,
                  width: imgWidth,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: imgWidth,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('No image available'),
                  ),
                ),
              ],
            ),
          ),

          // Danh sách bình luận
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(comments[index][0]), // Lấy ký tự đầu làm avatar
                  ),
                  title: Text(comments[index]),
                );
              },
            ),
          ),

          // Thanh nhập và gửi bình luận
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cmtCtrl,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment, // Thêm bình luận mới
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
