import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ydw_border/models/user_info.dart';

class UserInfoService {
  static Future<UserInfo> getUserInfo(String token) async {
    final url = Uri.parse('http://192.168.1.98:3000/auth/profile');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final userData = json.decode(response.body);
    return UserInfo(name: userData['username'], email: userData['useremail']);
  }
}
