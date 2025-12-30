/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 계좌 등록 화면의 상태 관리 (약관 동의 기능 추가)
*/

import 'package:flutter/material.dart';
import '../services/payment/account_service.dart';

class AccountRegistrationProvider extends ChangeNotifier {
  final AccountService _accountService = AccountService();

  // 1. 상태(State): 이 화면에서 관리해야 할 모든 데이터
  // =======================================================

  String? _paymentBank;
  String? get paymentBank => _paymentBank;

  String? _paymentAccountNumber;
  String? get paymentAccountNumber => _paymentAccountNumber;

  String? _verificationCode;

  bool _isAccountVerified = false;
  bool get isAccountVerified => _isAccountVerified;

  bool _agreedToPersonal = false;
  bool get agreedToPersonal => _agreedToPersonal;

  bool _agreedToThirdParty = false;
  bool get agreedToThirdParty => _agreedToThirdParty;

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

  void setAgreement(String type, bool value) {
    if (type == 'personal') {
      _agreedToPersonal = value;
    } else if (type == 'thirdParty') {
      _agreedToThirdParty = value;
    }
    notifyListeners();
  }

  Future<void> requestVerificationCode() async {
    if (_paymentAccountNumber == null || _paymentAccountNumber!.isEmpty) return;

    _startLoading();
    _verificationCode = await _accountService.requestVerificationCode(_paymentAccountNumber!);
    print("Provider: Service로부터 인증 코드 [$_verificationCode]를 받았습니다.");
    _finishLoading();
  }

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

  Future<bool> registerAccount() async {
    if (!_isAccountVerified) {
      print("Provider: 계좌 인증이 완료되지 않았습니다.");
      return false;
    }

    _startLoading();

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
