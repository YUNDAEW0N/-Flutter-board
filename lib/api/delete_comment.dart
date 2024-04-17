import 'package:http/http.dart' as http;

class DeleteCommentService {
  static Future<void> deleteComment(int commentId, String token) async {
    final url = Uri.parse('http://192.168.1.98:3000/comments/$commentId');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 댓글 삭제 성공
        print('댓글이 삭제되었습니다.');
      } else {
        // 댓글 삭제 실패
        throw Exception('댓글 삭제에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('댓글 삭제 중 오류가 발생했습니다: $e');
    }
  }
}
