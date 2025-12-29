/*
  날짜 : 2025-12-29
  내용 : AuthProvider 생성 (로그인 상태 관리)
  이름 : 박효빈
*/

import 'package:flutter/material.dart';
import 'package:bnkpart2/services/auth/token_storage_service.dart';

/// 인증 상태 관리 Provider
/// - 로그인 여부 확인
/// - 토큰 저장/삭제
class AuthProvider with ChangeNotifier {

  final _tokenStorageService = TokenStorageService();

  // 로그인 여부 상태
  bool _isLoggedIn = false;

  /// 로그인 여부 getter
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    // 앱 실행 시 로그인 여부 검사
    _checkLoginStatus();
  }

  /// 저장된 토큰 확인하여 로그인 상태 체크
  Future<void> _checkLoginStatus() async {
    final token = await _tokenStorageService.readToken();

    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      // provider - 해당 Provider를 구독하고 있는 Consumer에게 알림
      notifyListeners();
    }
  }

  /// 로그인 처리
  /// @param token JWT 토큰
  Future<void> login(String token) async {
    await _tokenStorageService.saveToken(token);
    _isLoggedIn = true;
    // 해당 Provider를 구독하고 있는 Consumer에게 알림
    notifyListeners();
  }

  /// 로그아웃 처리
  Future<void> logout() async {
    _isLoggedIn = false;
    await _tokenStorageService.deleteToken();
    // 해당 Provider를 구독하고 있는 Consumer에게 알림
    notifyListeners();
  }
}