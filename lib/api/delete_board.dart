import 'package:http/http.dart' as http;

class DeleteBoardService {
  static Future<void> deleteBoard(int boardId, String token) async {
    final url = Uri.parse('http://192.168.1.98:3000/boards/$boardId');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 게시글 삭제 성공
        print('게시글이 삭제되었습니다.');
      } else {
        // 게시글 삭제 실패
        throw Exception('게시글 삭제에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('게시글 삭제 중 오류가 발생했습니다: $e');
    }
  }
}
