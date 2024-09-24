import 'package:flutter/material.dart';
import 'package:s_social/features/screen/home/model/post_data.dart';

class PostWidget extends StatefulWidget {
  final PostData data;
  final VoidCallback onTap;

  const PostWidget({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final imgWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.data.userImg),
            ),
            title: Text(widget.data.userName),
            subtitle: Text(widget.data.content),
            onTap: widget.onTap,
          ),
          Image.network(widget.data.postImg),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                          if (isLiked) {
                            widget.data.like += 1;
                          } else {
                            widget.data.like -= 1;
                          }
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    Text('${widget.data.like} Likes'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                      },
                    ),
                    SizedBox(width: 5),
                    Text('${widget.data.cmtNo} Comments'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                      },
                    ),
                    SizedBox(width: 5),
                    Text('${widget.data.share} Shares'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
