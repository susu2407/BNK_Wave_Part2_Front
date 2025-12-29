/*
  날짜 : 2025-12-29
  이름 : 이수연
  내용 : 계좌 등록과 관련된 API 통신 및 비즈니스 로직 처리
*/

class AccountService {
  /// 1원 이체 인증번호 요청 (Mock)
  /// 
  /// 실제 앱에서는 이 부분에서 서버 API를 호출합니다.
  /// 여기서는 요청을 흉내 내고, 성공 시 '1234' 코드를 반환합니다.
  Future<String?> requestVerificationCode(String accountNumber) async {
    // API 통신을 흉내 내기 위한 지연
    await Future.delayed(Duration(seconds: 1)); 

    // 성공적으로 응답을 받았다고 가정하고, 인증 코드 반환
    print("AccountService: 계좌($accountNumber)로 인증 코드 '1234'를 요청했습니다.");
    return "1234";
  }

  /// 결제 계좌 최종 등록 (Mock)
  ///
  /// 실제 앱에서는 이 부분에서 서버 API를 호출하여 데이터를 저장합니다.
  Future<bool> registerAccount({
    required String bank,
    required String accountNumber,
  }) async {
    print("AccountService: 서버로 데이터 전송 시도 -> Bank=$bank, Account=$accountNumber");
    
    // API 통신을 흉내 내기 위한 지연
    await Future.delayed(Duration(seconds: 1));

    // 등록에 성공했다고 가정하고 true 반환
    print("AccountService: 계좌 등록 성공");
    return true;
  }
}
