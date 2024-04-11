import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
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
        title: const Text('회원 가입'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailInput(),
                const SizedBox(height: 15),
                passwordInput(),
                const SizedBox(height: 15),
                submitButton(),
                const SizedBox(height: 15),
              ],
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
          return '이메일은 필수사항입니다.';
        }

        if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(val)) {
          return '잘못된 이메일 형식입니다.';
        }

        return null;
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
          return '비밀번호는 필수 사항입니다.';
        }

        if (val.length < 8) {
          return '8자 이상 입력해 주세요!';
        }

        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Password를 입력해 주세요.',
        label: Text('PASSWORD'),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        // 로그인 성공시 게시판 페이지로, 실패시 실패알림
        if (_key.currentState!.validate()) {
          try {
            final credential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: _idController.text,
                  password: _pwController.text,
                )
                .then((_) => Navigator.pushNamed(context, "/login"));
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              debugPrint('8자리의 비밀번호를 입력해 주세요.');
            } else if (e.code == 'wrong-password') {
              debugPrint('잘못된 비밀번호 입니다.');
            }
          } catch (e) {
            print(e.toString());
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: const Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
