/*
  날짜 : 2025-12-29
  이름 : 이수연
  내용 : 계좌 등록 화면의 상태를 관리하고, 실제 로직은 Service에 위임합니다.
*/

import 'package:flutter/material.dart';
import '../service/payment/account_service.dart';

/// 계좌 등록 및 인증 과정을 관리하는 상태 관리자(Provider)
class AccountRegistrationProvider extends ChangeNotifier {

  // 의존성 주입: 실제 로직을 처리할 서비스
  final AccountService _accountService = AccountService();

  // 1. 상태(State): 이 화면에서 관리해야 할 모든 데이터
  // =======================================================

  String? _paymentBank;
  String? get paymentBank => _paymentBank;

  String? _paymentAccountNumber;
  String? get paymentAccountNumber => _paymentAccountNumber;
  
  String? _verificationCode; // Service로부터 받은 인증 코드

  bool _isAccountVerified = false;
  bool get isAccountVerified => _isAccountVerified;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  // 2. 로직(Logic): UI 상태 변경 및 Service 호출
  // =======================================================

  void setPaymentBank(String bank) {
    _paymentBank = bank;
    notifyListeners();
  }

  void setPaymentAccountNumber(String accountNumber) {
    _paymentAccountNumber = accountNumber;
    notifyListeners();
  }

  /// '인증번호 받기' 버튼 로직
  Future<void> requestVerificationCode() async {
    if (_paymentAccountNumber == null || _paymentAccountNumber!.isEmpty) return;

    _startLoading();

    // 실제 로직은 Service에 위임
    _verificationCode = await _accountService.requestVerificationCode(_paymentAccountNumber!);
    print("Provider: Service로부터 인증 코드 [$_verificationCode]를 받았습니다.");
    
    _finishLoading();
  }

  /// '확인' 버튼을 눌러 인증번호 제출
  bool submitVerificationCode(String userInputCode) {
    if (userInputCode == _verificationCode) {
      _isAccountVerified = true;
      print("Provider: 인증 성공!");
      notifyListeners();
      return true;
    } else {
      print("Provider: 인증 실패. 코드가 다릅니다.");
      return false;
    }
  }

  /// 최종 '등록하기' 버튼 로직
  Future<bool> registerAccount() async {
    if (!_isAccountVerified) {
      print("Provider: 계좌 인증이 완료되지 않았습니다.");
      return false;
    }

    _startLoading();

    // 실제 로직은 Service에 위임
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
