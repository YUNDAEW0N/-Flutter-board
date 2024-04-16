import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/provider/userinfo_provider.dart';
import 'package:ydw_border/screen/home_page.dart';
import 'package:ydw_border/screen/profile_page.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userEmailProvider와 userNameProvider의 값 가져오기
    final username = ref.read(userInfoProvider).value!.name;
    final useremail = ref.read(userInfoProvider).value!.email;

    const imageurl = 'assets/images/kfjungle.png';

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: const CircleAvatar(
            backgroundImage: AssetImage(imageurl),
          ),
          accountName: Text(username),
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
            color: Colors.white,
          ),
          title: const Text('게시판'),
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
            color: Colors.white,
          ),
          title: const Text('마이 페이지'),
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
    );
  }
}
