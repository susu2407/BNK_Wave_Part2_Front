import 'dart:convert';

import 'package:bnkpart2/models/entity/member_card.dart';
import 'package:http/http.dart' as http;

class AccountService {

  final String baseUrl = "http://10.0.2.2:8080/bnk2WAVE";

  /// [실제 API] 결제 계좌 정보를 서버에 최종 저장합니다.
  Future<Map<String, dynamic>> accountRegister(MemberCard memberCard) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/payment/save'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(memberCard.toJson())
      );

      if(response.statusCode == 200){ // 정상 응답
        return jsonDecode(response.body);
      } else {
        throw Exception('statusCode : ${response.statusCode}');
      }
    }catch (err){
      throw Exception('에러발생 : $err');
    }
  }

  /// [Mock API] 1원 이체 인증번호 요청을 흉내 냅니다.
  ///
  /// 실제 앱에서는 이 부분에서 서버 API를 호출해야 하지만,
  /// 여기서는 요청을 흉내 내고, 성공 시 고정된 코드 '1234'를 반환합니다.
  Future<String?> requestVerificationCode(String accountNumber) async {
    // API 통신을 흉내 내기 위한 1초 지연
    await Future.delayed(Duration(seconds: 1));

    // 성공적으로 응답을 받았다고 가정하고, 인증 코드 반환
    print("AccountService: 계좌($accountNumber)로 인증 코드 '1234'를 요청했습니다. (Mock)");
    return "1234";
  }
}
