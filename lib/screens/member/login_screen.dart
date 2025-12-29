import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnkpart2/screens/member/terms_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/member_service.dart';
import '../../services/token_storage_service.dart';
import 'findid_screen.dart';
import 'findpassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _idController = TextEditingController();
  final _pwController = TextEditingController();

  final service = MemberService();
  final tokenStorageService = TokenStorageService();

  void _procLogin() async {

    final usid = _idController.text;
    final pass = _pwController.text;

    if(usid.isEmpty || pass.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디, 비번 입력하세요.'))
      );
      return;
    }

    try {
      // 서비스 호출
      Map<String, dynamic> jsonData = await service.login(usid, pass);
      String? accessToken = jsonData['accessToken'];
      log('accessToken : $accessToken');

      if(accessToken != null){
        // 토큰 저장(Provider로 저장)
        context.read<AuthProvider>().login(accessToken);

        // 로그인 화면 닫기
        Navigator.of(context).pop();
      }

    }catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString()))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/cardiology.png'),
              const SizedBox(height: 40,),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                labelText: '아이디 입력',
                border: OutlineInputBorder()
              ),),
              const SizedBox(height: 15,),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 입력',
                  border: OutlineInputBorder()
              ),),
              const SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _procLogin,
                  child: const Text('로그인', style: TextStyle(fontSize: 25, color: Colors.black),)
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FindIdScreen()),
                      );
                    },
                    child: const Text('아이디 찾기'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FindPasswordScreen()),
                      );
                    },
                    child: const Text('PW찾기'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TermsScreen()),
                      );
                    },
                    child: const Text('회원가입'),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

}