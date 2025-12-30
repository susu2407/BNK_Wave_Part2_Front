/*
  날짜 : 2025-12-18
  이름 : 이수연
  내용 : 계좌 등록/수정할 카드 선택 화면 - 1

  - 보유 카드 목록 보이기
  - 카드 타입(신용/체크)에 맞게 카드 목록 불러오기
  - 불러온 카드 중 카드 선택 시 카드 리스트 테두리에 강조색 넣어서, 무엇을 선택했는지 시각적으로 보이기
  - 카드 선택 시 하단의 '다음' 버튼 활성화
  - 다음 버튼 눌렀을 때에 -> 선택한 카드에 연결된 계좌 정보를 등록/수정 할 수 있도록 '선택한 카드 정보' 넘기기
  - 다음 버튼 눌렀을 때에, 계좌 입력 화면(account_input_screen)으로 이동

*/
import 'package:bnkpart2/models/dto/account_dto.dart';
import 'package:bnkpart2/screens/payment/card_account_input_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: PaymentAccountChangeScreen(),
    debugShowCheckedModeBanner: false,  // 디버그 모드 띠 숨기기 위한 설정
  ));
}

// 설계도 역할
class PaymentAccountChangeScreen extends StatefulWidget {
  const PaymentAccountChangeScreen({super.key});

  @override
  State<PaymentAccountChangeScreen> createState() => _PaymentAccountChangeScreenState();
}

// 기억 장치 역할
class _PaymentAccountChangeScreenState extends State<PaymentAccountChangeScreen> {
  int _selectedTab = 0; // 0: 신용, 1: 체크
  int? _selectedCardId; // 테이블의 PK인 MEMBER_CARD_ID를 저장

  // 1. [데이터] 다음 화면(DTO)에 필요한 정보를 포함하도록 데이터 보강
  final List<Map<String, dynamic>> _myCardList = [
    {
      'MEMBER_CARD_ID': 1,
      'CARD_NAME': 'BNK부산은행 Rex카드',
      'CARD_TYPE': '신용',
      'CARD_NUMBER': '1234-5678-9012-3456',
      'PAYMENT_BANK': '신한은행',
      'PAYMENT_ACCOUNT': '110-123-456789',
      'CARD_IMAGE_URL': 'https://api.lorem.space/image/creditcard?w=400&h=250&hash=A1B2C3D4',
    },
    {
      'MEMBER_CARD_ID': 2,
      'CARD_NAME': 'BNK부산은행 체크카드',
      'CARD_TYPE': '체크',
      'CARD_NUMBER': '5555-4444-3333-2222',
      'PAYMENT_BANK': '국민은행',
      'PAYMENT_ACCOUNT': '4567-02-12345',
      'CARD_IMAGE_URL': 'https://api.lorem.space/image/creditcard?w=400&h=250&hash=B2C3D4E5',
    },
    {
      'MEMBER_CARD_ID': 3,
      'CARD_NAME': 'BNK부산은행 Rex카드',
      'CARD_TYPE': '신용',
      'CARD_NUMBER': '9999-0000-1111-2222',
      'PAYMENT_BANK': null,
      'PAYMENT_ACCOUNT': null,
      'CARD_IMAGE_URL': 'https://api.lorem.space/image/creditcard?w=400&h=250&hash=C3D4E5F6',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column( // 전체 뼈대
        children: [
          // --- [상단 고정 영역 시작] ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  '내 카드의 결제계좌를\n쉽게 변경해보세요.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.4),
                ),
                const SizedBox(height: 30),
                _buildToggleTabs(), // 신용/체크 탭
                const SizedBox(height: 40),
                const Text(
                  '카드 · 계약 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          Expanded( // 유연한 확장(남은 공간 모두 차지)
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _myCardList.length,
              itemBuilder: (context, index) {
                // 메서드 분리 호출
                return _buildCardItem(_myCardList[index]);
              },
            ),
          ),
          _buildNoticeSection(),
          _buildBottomButton(), // 하단 버튼 고정 영역
        ],
      ),
    );
  }

  // 2. [메서드] 선택 가능한 카드 아이템 빌더
  Widget _buildCardItem(Map<String, dynamic> cardData) {
    final int cardId = cardData['MEMBER_CARD_ID'];
    final bool isSelected = _selectedCardId == cardId;

    // 카드번호 앞 4자리 추출 로직
    final String fullNumber = cardData['CARD_NUMBER'];
    final String displayId = fullNumber.substring(0, 4);

    return GestureDetector(
      onTap: () => setState(() => _selectedCardId = cardId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 16),
        transform: isSelected ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cardData['CARD_TYPE']} | $displayId',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // [수정] 계좌 등록 여부에 따라 다른 텍스트 표시
                  Text(
                    (cardData['PAYMENT_BANK'] != null && cardData['PAYMENT_ACCOUNT'] != null)
                        ? '${cardData['PAYMENT_BANK']} ${cardData['PAYMENT_ACCOUNT']}'
                        : '결제 계좌를 등록해주세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? Colors.white70
                          : ((cardData['PAYMENT_BANK'] != null)
                              ? Colors.black45
                              : Colors.black45),
                      fontWeight: (cardData['PAYMENT_BANK'] != null)
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.credit_card,
              color: isSelected ? Colors.white24 : Colors.black12,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }

  // 앱바 위젯
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
      title: const Text('결제계좌', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
    );
  }

  // 상단 탭 위젯 : 신용,체크
  Widget _buildToggleTabs() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem('신용', 0),
          _buildTabItem('체크', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 안내 문구 섹션
  Widget _buildNoticeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _noticeRow('청구방식이 통합된 경우, 결제정보는 하나로 보관됩니다.'),
          _noticeRow('점검 시간(23:30~00:00)에는 서비스 이용이 제한될 수 있습니다.'),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _noticeRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('• $text', style: const TextStyle(fontSize: 12, color: Colors.black38, height: 1.5)),
    );
  }

  // 하단 버튼
  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          // [수정] onPressed 로직 구현
          onPressed: _selectedCardId != null
              ? () {
                  // 1. 선택된 카드 데이터 찾기
                  final selectedCardData = _myCardList.firstWhere(
                    (card) => card['MEMBER_CARD_ID'] == _selectedCardId,
                    orElse: () => {}, // 없으면 빈 맵 반환
                  );

                  // 데이터가 없으면 아무것도 하지 않음 (안전 장치)
                  if (selectedCardData.isEmpty) return;

                  // 2. 다음 화면으로 전달할 DTO 생성
                  final dto = AccountInputDto(
                    cardId: selectedCardData['MEMBER_CARD_ID'],
                    cardName: selectedCardData['CARD_NAME'],
                    bankName: selectedCardData['PAYMENT_BANK'] ?? "은행 정보 없음",
                    cardImageUrl: selectedCardData['CARD_IMAGE_URL'],
                  );

                  // 3. 계좌 입력 화면으로 이동하면서 DTO 전달
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CardAccountInputScreen(selectedCard: dto),
                    ),
                  );
                }
              : null, // 카드가 선택되지 않으면 버튼 비활성화
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text('다음', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
