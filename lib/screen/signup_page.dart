import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ydw_border/screen/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _nameController = TextEditingController();

  void _signUp() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
    }

    final url = Uri.parse('http://192.168.1.98:3000/auth/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "useremail": _emailController.text,
        "username": _nameController.text,
        "password": _pwController.text,
      }),
    );
    print('response.body : ${response.body}');

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: '회원가입이 완료되었습니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 20.0,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 95, 93, 93),
      );
      if (context.mounted) {
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
      }
    } else {
      Map<String, dynamic> data = json.decode(response.body);
      String errormessage = data['message'];

      if (errormessage == 'Email already exists') {
        Fluttertoast.showToast(
          msg: '이미 등록된 E-mail 입니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0, // 폰트 크기
          textColor: Colors.white, // 텍스트 색상
          backgroundColor: const Color.fromARGB(255, 95, 93, 93), // 배경색
        );
      }

      if (errormessage == 'Username already exists') {
        Fluttertoast.showToast(
          msg: '이미 등록된 닉네임 입니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0, // 폰트 크기
          textColor: Colors.white, // 텍스트 색상
          backgroundColor: const Color.fromARGB(255, 95, 93, 93), // 배경색
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
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
                  nameInput(),
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
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
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

  TextFormField nameInput() {
    return TextFormField(
      controller: _nameController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return '닉네임은 필수사항입니다.';
        }

        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '닉네임을 입력해 주세요.',
        label: Text('NickName'),
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
      onPressed: _signUp,
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
