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
  Future<String?> requestVerificationCode(String accountNumber) async {
    await Future.delayed(Duration(seconds: 1));
    print("AccountService: 계좌($accountNumber)로 인증 코드 '1234'를 요청했습니다. (Mock)");
    return "1234";
  }

  /// [Mock API] 최종 계좌 등록을 흉내 내는 임시 함수
  Future<bool> registerAccount({
    required String bank,
    required String accountNumber,
  }) async {
    print("AccountService: [Mock] 서버로 데이터 전송 시도 -> Bank=$bank, Account=$accountNumber");
    await Future.delayed(Duration(seconds: 1));
    print("AccountService: [Mock] 계좌 등록 성공");
    return true;
  }
}
