/*
  날짜 : 2025-12-24
  이름 : 이수연

  내용 : 카드 목록 및 계좌 등록에 필요한 DTO
*/

import '../entity/card_basic.dart';
import '../entity/member_card.dart';

/// 화면(UI)에 데이터를 뿌려주기 위해
/// 두 개의 Entity를 하나로 합친 데이터 전송 객체(DTO)
class CardViewDto {
  final CardBasic basic;    // 카드 상품 공통 정보 (카드명, 이미지 등)
  final MemberCard member;  // 사용자 개인 보유 정보 (계좌번호, 카드번호 등)

  CardViewDto({
    required this.basic,
    required this.member,
  });

  // [핵심 가공 로직] 카드명 + 계좌번호 조합
  String get displayTitle => basic.cardName;

  // [핵심 가공 로직] 타입 | 카드번호 앞 4자리
  String get displaySubTitle {
    final type = basic.cardType; // 신용/체크
    final shortNo = member.cardNumber.length >= 4
        ? member.cardNumber.substring(0, 4)
        : "****";
    return "$type | $shortNo";
  }

  // [식별자] 카드 고유 ID (PK)
  int get cardId => basic.cardId;

  // [이미지] 카드 이미지 경로
  String get imageUrl => basic.cardImageUrl;
}

/// 계좌 등록 화면으로 이동할 때, 선택된 카드의 정보를 전달하기 위한 DTO
class AccountInputDto {
  final int cardId; // 어느 카드에 계좌를 등록할지 식별
  final String cardName;
  final String bankName; // 카드 발급 은행
  final String cardImageUrl;

  AccountInputDto({
    required this.cardId,
    required this.cardName,
    required this.bankName,
    required this.cardImageUrl,
  });

  /// CardViewDto로부터 AccountInputDto를 생성
  factory AccountInputDto.fromCardView(CardViewDto cardView) {
    return AccountInputDto(
      cardId: cardView.cardId,
      cardName: cardView.basic.cardName,
      bankName: cardView.basic.bankName,
      cardImageUrl: cardView.imageUrl,
    );
  }
}
