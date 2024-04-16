import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/api/deletecomment.dart';
import 'package:ydw_border/api/getcomment.dart';
import 'package:ydw_border/api/sendcomment.dart';
import 'package:ydw_border/models/comment_item.dart';
import 'package:ydw_border/provider/token_provider.dart';
import 'package:ydw_border/provider/userinfo_provider.dart';

class CommentPage extends ConsumerStatefulWidget {
  const CommentPage({
    super.key,
    required this.postId,
  });

  final int postId;

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends ConsumerState<CommentPage> {
  List<CommentItem> comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() async {
    try {
      final comments = await GetCommentService.getComments(widget.postId);
      setState(() {
        this.comments = comments;
      });
    } catch (e) {
      print(e);
    }
  }

  void _addComment(String text) {
    if (text.isNotEmpty) {
      final String token = ref.read(tokenProvider.notifier).state;
      final String username = ref.read(userInfoProvider).value!.name;
      setState(() {
        comments.add(
          CommentItem(username: username, comment: text),
        );
        _commentController.clear(); // 입력 필드 클리어
      });
      CommentService.postComment(widget.postId, text, token);
    }
  }

  void _deleteComment(int index) async {
    try {
      final String token = ref.read(tokenProvider.notifier).state;

      final int commentId = comments[index].commentId!;

      // 삭제를 요청할 때 서버에 해당 댓글의 인덱스와 작성자 정보를 전달
      await DeleteCommentService.deleteComment(commentId, token);

      // 삭제 성공 시 UI에서 해당 댓글 제거
      setState(() {
        comments.removeAt(index);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('삭제할 수 없음.'),
          content: const Text('본인이 작성한 댓글만 삭제가 가능합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: comments.isNotEmpty
                ? ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://placekitten.com/200/200"), // 예시 프로필 이미지
                        ),
                        title: Text(comment.username),
                        subtitle: Text(comment.comment),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _deleteComment(index);
                            });
                          },
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment,
                          size: 96,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '아직 댓글이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '가장 먼저 댓글을 남겨보세요.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _addComment(_commentController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
