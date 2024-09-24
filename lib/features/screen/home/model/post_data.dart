import 'package:firebase_auth/firebase_auth.dart';

class PostData {
  String userName;
  String userImg;
  String content;
  String postImg;
  int like;
  int cmtNo;
  int share;

  PostData({
    required this.userName,
    required this.userImg,
    required this.content,
    required this.postImg,
    required this.like,
    required this.cmtNo,
    required this.share,
  });

  factory PostData.fromMap(Map<dynamic, dynamic> map) {
    return PostData(
      userName: map['userName'],
      userImg: map['userImg'],
      content: map['content'],
      postImg: map['postImg'],
      like: map['like'],
      cmtNo: map['commentNo'],
      share: map['share'],
    );
  }

  static Future<String?> getUserNameFromFirebaseAuth() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}

Future<PostData> createPostData() async {
  String? email = await PostData.getUserNameFromFirebaseAuth();
  return PostData(
    userName: email ?? 'Anonymous',
    userImg: 'assets/images/logo_s.png',          // example
    content: 'This is a new post',
    postImg: 'assets/images/logo_google.png',     // example
    like: 0,
    cmtNo: 0,
    share: 0,
  );
}
