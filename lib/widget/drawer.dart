import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/provider/userinfo_provider.dart';
import 'package:ydw_border/screen/home_page.dart';
import 'package:ydw_border/screen/profile_page.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userEmailProvider와 userNameProvider의 값 가져오기
    final username = ref.watch(userInfoProvider).value!.name;
    final useremail = ref.watch(userInfoProvider).value!.email;

    const imageurl = 'assets/images/kfjungle.png';

    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 117, 116, 116),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage(imageurl),
              ),
              accountName: Text(
                username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(useremail),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 117, 116, 116),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.comment,
                color: Colors.white, // 변경된 아이콘 색상
              ),
              title: const Text(
                '게시판',
                style: TextStyle(
                  color: Colors.white, // 변경된 텍스트 색상
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.white, // 변경된 아이콘 색상
              ),
              title: const Text(
                '내가 쓴 게시글',
                style: TextStyle(
                  color: Colors.white, // 변경된 텍스트 색상
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const ProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
