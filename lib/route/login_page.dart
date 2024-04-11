import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('JUNGLE 게시판'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/kfjungle.png'),
                  emailInput(),
                  const SizedBox(height: 15),
                  passwordInput(),
                  const SizedBox(height: 15),
                  loginButton(context),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _idController,
      autofocus: true, //로그인 페이지 진입시 e메일 필드에 자동 포커스
      validator: (val) {
        if (val!.isEmpty) {
          return 'e-mail을 입력해 주세요.';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'e-mail을 입력해 주세요.',
        label: Text('E-MAIL'),
      ),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _pwController,
      obscureText: true,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'Password를 입력해 주세요.';
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Password를 입력해 주세요.',
        label: Text('PASSWORD'),
      ),
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // 로그인 성공시 게시판 페이지로, 실패시 실패알림
        if (_key.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _idController.text, password: _pwController.text)
                .then((_) => Navigator.pushNamed(context, "/"));
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              debugPrint(e.code);
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('등록 되지 않은 사용자'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              } else if (e.code == 'wrong-password') {}
            }
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
