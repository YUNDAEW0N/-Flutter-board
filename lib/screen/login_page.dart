import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ydw_border/models/user_info.dart';
import 'package:ydw_border/provider/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ydw_border/provider/userinfo_provider.dart';
import 'package:ydw_border/screen/home_page.dart';
import 'package:ydw_border/screen/signup_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  void _login() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
    }

    final url = Uri.parse('http://192.168.1.98:3000/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "useremail": _emailController.text,
        "password": _pwController.text,
      }),
    );
    // print(response.body);
    // print(response.statusCode);

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      String accessToken = data['accessToken'];
      ref.read(tokenProvider.notifier).state = accessToken;
      ref.watch(userInfoProvider);

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
        );
      }
    } else {
      // Handle error
      Map<String, dynamic> data = json.decode(response.body);
      String errormessage = data['message'];

      if (errormessage == 'Could not find user') {
        Fluttertoast.showToast(
          msg: '등록 되지 않은 사용자 입니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 20.0, // 폰트 크기
          textColor: Colors.white, // 텍스트 색상
          backgroundColor: const Color.fromARGB(255, 95, 93, 93), // 배경색
        );
      } else {
        Fluttertoast.showToast(
          msg: '비밀번호가 일치하지 않습니다.',
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
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SignupPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return child;
                          },
                        ),
                      );
                    },
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
      controller: _emailController,
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
      onPressed: _login,
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
