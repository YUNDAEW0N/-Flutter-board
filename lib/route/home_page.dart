import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ydw_border/route/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('JUNGLE 게시판'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async => await FirebaseAuth.instance
                      .signOut()
                      .then((_) => Navigator.pushNamed(context, "/login")),
                ),
              ],
            ),
            drawer: const Drawer(
                //...
                ),
            body: const Center(
              child: Text(
                '게시판 메인 화면',
                style: TextStyle(fontSize: 28.0),
              ),
            ),
          );
        }
      },
    );
  }
}
