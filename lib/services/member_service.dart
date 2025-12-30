import 'dart:convert';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/entity/member.dart';

class MemberService {

  final String baseUrl = "http://10.0.2.2:8080/ch09";

  Future<Map<String, dynamic>> login(String usid, String pass) async {

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'loginId': usid,
        'password': pass,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('로그인 실패');
    }
  }

  Future<Map<String, dynamic>> register(Member member) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/user/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(member.toJson())
      );

      if(response.statusCode == 200){
        // savedUser 반환
        return jsonDecode(response.body);

      } else {
        throw Exception('statusCode : ${response.statusCode}');
      }
    }catch (err){
      throw Exception('에러발생 : $err');
    }
  }

  Future<String> findId(String name, String email) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/member/find-id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['loginId'];
    } else {
      throw Exception('아이디를 찾을 수 없습니다.');
    }
  }

}