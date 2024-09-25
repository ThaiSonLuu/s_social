class CommentData {
  String userName;
  String userImg;
  String comment;

  CommentData({
    required this.userName,
    required this.userImg,
    required this.comment,
  });

  factory CommentData.fromMap(Map<dynamic, dynamic> map) {
    return CommentData(
      userName: map['userName'],
      userImg: map['userImg'],
      comment: map['comment'],
    );
  }
}
