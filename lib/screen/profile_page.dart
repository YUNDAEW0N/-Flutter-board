import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ydw_border/screen/login_page.dart';
import 'package:ydw_border/widget/drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지'),
        actions: [
          IconButton(
            onPressed: () {
              Fluttertoast.showToast(
                msg: '로그아웃 되었습니다.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                fontSize: 20.0, // 폰트 크기
                textColor: Colors.white, // 텍스트 색상
                backgroundColor: const Color.fromARGB(255, 95, 93, 93), // 배경색
              );
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child;
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout_sharp),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: const Center(
        child: Text('임시'),
      ),
    );
  }
}
