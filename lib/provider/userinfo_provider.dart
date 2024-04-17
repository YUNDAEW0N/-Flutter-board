import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/api/user_info.dart';
import 'package:ydw_border/models/user_info.dart';
import 'package:ydw_border/provider/token_provider.dart';

final userInfoProvider = FutureProvider<UserInfo>((ref) async {
  final token = ref.read(tokenProvider.notifier).state;
  final userInfo = await UserInfoService.getUserInfo(token);
  return userInfo;
});

final userEmailProvider = StateProvider<String>((ref) => '');
final userNameProvider = StateProvider<String>((ref) => '');
