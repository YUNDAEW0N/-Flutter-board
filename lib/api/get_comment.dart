import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ydw_border/models/comment_item.dart';

class GetCommentService {
  static Future<List<CommentItem>> getComments(int postId) async {
    final url = Uri.parse('http://192.168.1.98:3000/comments/$postId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final test = responseData
          .map((data) => CommentItem(
                username: data['username'],
                comment: data['comment'],
                commentId: data['id'],
              ))
          .toList();

      return test;
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
