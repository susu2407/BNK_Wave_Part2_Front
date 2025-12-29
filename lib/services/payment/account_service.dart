import 'dart:convert';

import 'package:bnkpart2/models/entity/member_card.dart';
import 'package:http/http.dart' as http;

class AccountService {

  final String baseUrl = "http://10.0.2.2:8080/bnk2WAVE";

  Future<Map<String, dynamic>> accountRegister(MemberCard memberCard) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/payment/save'),  // 요청할 경로 설정
          headers: {"Content-Type": "application/json"}, // 헤더 설정
          body: jsonEncode(memberCard.toJson()) // 이거는 이제 post였기에 있었던 body 설정
      ); // 요청

      if(response.statusCode == 200){ // 정상 응답
        // savedUser 반환
        return jsonDecode(response.body);

      } else {
        throw Exception('statusCode : ${response.statusCode}');
      }
    }catch (err){
      throw Exception('에러발생 : $err');
    }
  }

}