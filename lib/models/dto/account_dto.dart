/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 카드 목록 및 계좌 등록에 필요한 DTO
*/

/// 계좌 등록 화면(Input Screen)이 카드 정보를 표시하는 데 필요한 모든 데이터를 전달하는 DTO.
class AccountInputDto {
  final int cardId;
  final String cardName;
  final String? bankName;
  final String cardImageUrl;
  final String cardType;
  final String cardNumber;
  final String? paymentAccount; // 기존 계좌번호 표시를 위한 필드

  AccountInputDto({
    required this.cardId,
    required this.cardName,
    this.bankName,
    required this.cardImageUrl,
    required this.cardType,
    required this.cardNumber,
    this.paymentAccount, // required가 아님 (null일 수 있으므로)
  });

  // card_selection_screen의 더미 데이터 형식에 맞춤
  factory AccountInputDto.fromMap(Map<String, dynamic> cardData) {
    return AccountInputDto(
      cardId: cardData['MEMBER_CARD_ID'],
      cardName: cardData['CARD_NAME'],
      bankName: cardData['PAYMENT_BANK'],
      cardImageUrl: cardData['CARD_IMAGE_URL'],
      cardType: cardData['CARD_TYPE'],
      cardNumber: cardData['CARD_NUMBER'],
      paymentAccount: cardData['PAYMENT_ACCOUNT'],
    );
  }
}
