import 'dart:convert';

import 'package:http/http.dart' as http;

class CommentService {
  static Future<void> postComment(
      int postId, String comment, String token) async {
    final url = Uri.parse('http://192.168.1.98:3000/comments');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'boardId': postId,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        print('댓글이 성공적으로 게시되었습니다.');
      } else {
        print('댓글 게시에 실패했습니다.');
        // 에러 처리
      }
    } catch (error) {
      print('댓글 게시 중 오류가 발생했습니다: $error');
      // 에러 처리
    }
  }
}
