import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bnkpart2/providers/auth_provider.dart';

/// 마이페이지 탭
class MyMain extends StatefulWidget {
  const MyMain({super.key});

  @override
  State<MyMain> createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> {
  /// 로그인 전 화면
  Widget _buildLogin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('로그인이 필요합니다.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: 로그인 화면으로 이동
            },
            child: const Text('로그인 이동'),
          ),
        ],
      ),
    );
  }

  /// 로그인 후 메인 화면
  Widget _buildLoggedIn() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 테두리가 포함된 상단 사용자 영역
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildUserHeader(),
            ),
            const SizedBox(height: 16),

            // 2. 테두리가 포함된 배너 슬라이드 광고
            _buildBannerSection(),
            const SizedBox(height: 20),

            // 3. 내 카드 섹션
            _buildMyCardHeader(),
            const SizedBox(height: 12),
            _buildCardInfoSection(),
            const SizedBox(height: 20),

            // 4. 받은 혜택 섹션
            _buildBenefitSection(),
            const SizedBox(height: 24),

            // 5. 마이 화면 편집 버튼
            _buildEditButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 상단 사용자 정보 헤더 (이미지 디자인 반영)
  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '효피바라', // 이미지의 텍스트로 수정
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildHeaderButton('메인페이지', () => Navigator.pop(context)),
            const SizedBox(width: 12),
            _buildHeaderButton('알림', () {
              // TODO: 알림 화면 이동
            }),
            const SizedBox(width: 12),
            _buildHeaderButton('로그아웃', () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
            }),
          ],
        )
      ],
    );
  }

  /// 헤더 버튼 공통 위젯
  Widget _buildHeaderButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  /// 배너 광고 섹션 (이미지 디자인 반영)
  Widget _buildBannerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '< 배너 슬라이드 광고 >',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 16),
          _buildBannerItem('MAP 이벤트 안내'),
          _buildBannerItem('MAP으로 이동'),
          const SizedBox(height: 20),
          _buildBannerItem('챗봇 홍보 이미지'),
          _buildBannerItem('챗봇으로 이동'),
        ],
      ),
    );
  }

  /// 배너 내부 아이템 (불렛 포인트)
  Widget _buildBannerItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// 내 카드 헤더
  Widget _buildMyCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '내 카드 >',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            // TODO: 카드 관리 화면 이동
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '내 카드 관리',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// 카드 정보 섹션
  Widget _buildCardInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('카드명 | 카드번호 뒷자리', style: TextStyle(fontSize: 13)),
                SizedBox(height: 16),
                Text('N월 이용금액', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
                SizedBox(height: 4),
                Text('000,000원', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: const Text('카드 이미지', style: TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  /// 받은 혜택 섹션
  Widget _buildBenefitSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('받은 혜택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildBenefitBar('교통', 0.6, '000,000원'),
          _buildBenefitBar('외식', 0.4, '000,000원'),
          _buildBenefitBar('여가', 0.2, '000,000원'),
        ],
      ),
    );
  }

  /// 혜택 프로그레스 바
  Widget _buildBenefitBar(String title, double value, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13)),
              Text(amount, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  /// 화면 편집 버튼
  Widget _buildEditButton() {
    return Center(
      child: SizedBox(
        width: 200,
        child: OutlinedButton(
          onPressed: () {},
          child: const Text('마이 화면 편집'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool isLoggedin = authProvider.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 페이지'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: isLoggedin ? _buildLoggedIn() : _buildLogin(),
    );
  }
}