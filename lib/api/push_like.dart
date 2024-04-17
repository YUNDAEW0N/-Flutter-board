import 'package:http/http.dart' as http;

class PushLikeService {
  static Future<void> pushLike(int postId, String token) async {
    final url = Uri.parse('http://192.168.1.98:3000/boards/$postId/like');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        // 좋아요 증가 성공
        print('좋아요가 증가되었습니다.');
      } else {
        // 좋아요 증가 실패
        throw Exception('좋아요 증가에 실패했습니다.');
      }
    } catch (e) {
      throw Exception('좋아요 증가 중 오류가 발생했습니다: $e');
    }
  }
}
