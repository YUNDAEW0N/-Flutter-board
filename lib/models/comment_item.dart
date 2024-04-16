class CommentItem {
  final String username;
  final String comment;
  final int? commentId;

  CommentItem({
    required this.username,
    required this.comment,
    this.commentId,
  });
}
