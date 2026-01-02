/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 계좌 등록 화면의 상태 관리 (UI 흐름 제어 기능 추가)
*/

import 'package:flutter/material.dart';
import '../services/payment/account_service.dart';

class AccountRegistrationProvider extends ChangeNotifier {
  final AccountService _accountService = AccountService();

  // --- 상태(State) 변수들 ---

  // [기존] 계좌 정보
  String? _paymentBank;
  String? get paymentBank => _paymentBank;
  String? _paymentAccountNumber;
  String? get paymentAccountNumber => _paymentAccountNumber;

  // [기존] 약관 동의
  bool _agreedToPersonal = false;
  bool get agreedToPersonal => _agreedToPersonal;
  bool _agreedToThirdParty = false;
  bool get agreedToThirdParty => _agreedToThirdParty;

  // [추가] 1원 인증 흐름을 제어하기 위한 상태
  bool _isVerificationRequested = false;
  bool get isVerificationRequested => _isVerificationRequested;

  // [기존] 1원 인증 성공 여부
  bool _isAccountVerified = false;
  bool get isAccountVerified => _isAccountVerified;

  String? _verificationCode; // Mock 인증 코드

  // [기존] 로딩 상태
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- 로직(Logic) 함수들 ---

  void setPaymentBank(String bank) {
    _paymentBank = bank;
    notifyListeners();
  }

  void setPaymentAccountNumber(String accountNumber) {
    _paymentAccountNumber = accountNumber;
    notifyListeners();
  }

  void setAgreement(String type, bool value) {
    if (type == 'personal') {
      _agreedToPersonal = value;
    } else if (type == 'thirdParty') {
      _agreedToThirdParty = value;
    }
    notifyListeners();
  }

  // [수정] '인증번호 요청' 버튼을 눌렀을 때의 로직
  Future<void> requestVerification() async {
    _startLoading();
    // 실제로는 Service를 호출하여 1원 송금을 요청해야 합니다.
    _verificationCode = "8025"; // Mock 데이터
    await Future.delayed(const Duration(seconds: 3)); // 통신 흉내
    _isVerificationRequested = true;
    _finishLoading();
  }

  // [수정] '확인 및 등록' 버튼을 눌렀을 때의 로직
  Future<bool> submitAndRegister(String userInputCode) async {
    // 1. 인증번호 검증
    if (userInputCode != _verificationCode) {
      print("Provider: 인증 실패. 코드가 다릅니다.");
      return false; // 인증 실패
    }
    _isAccountVerified = true;
    print("Provider: 인증 성공!");

    // 2. 최종 등록
    _startLoading();
    // 실제로는 Service를 호출하여 최종 등록합니다.
    final success = await _accountService.registerAccount(
      bank: _paymentBank!,
      accountNumber: _paymentAccountNumber!,
    );
    _finishLoading();
    return success;
  }

  // Helper methods
  void _startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
