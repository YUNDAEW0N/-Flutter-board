import 'dart:typed_data';

class BoardItem {
  BoardItem({
    required this.username,
    required this.body,
    required this.date,
    required this.like,
    required this.postId,
    this.image,
  });

  final String username;
  final String body;
  final String date;
  int like;
  final Uint8List? image;
  final int postId;
}
