import 'package:flutter/material.dart';

class CardNumberViewPage extends StatefulWidget {
  const CardNumberViewPage({super.key});

  @override
  State<CardNumberViewPage> createState() => _CardNumberViewPageState();
}

class _CardNumberViewPageState extends State<CardNumberViewPage> {
  final String cardNumber = '1234 5678 9012 3456';
  final String validThru = '12/28';

  bool showFullNumber = false;

  Future<void> authenticateAndShow() async {
    // 실제 서비스에서는 생체인증 / 비밀번호 인증 처리
    setState(() {
      showFullNumber = true;
    });

    // 10초 후 다시 마스킹
    await Future.delayed(const Duration(seconds: 10));
    if (!mounted) return;
    setState(() {
      showFullNumber = false;
    });
  }

  String maskedNumber(String number) {
    // 1234 **** **** 3456 형태
    return number.replaceRange(5, 14, '**** ****');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카드번호 확인'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 카드 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '카카오뱅크 개인사업자 상생카드',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 카드번호 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '카드번호',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    showFullNumber
                        ? cardNumber
                        : maskedNumber(cardNumber),
                    style: const TextStyle(
                      fontSize: 22,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '유효기간 $validThru',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              '※ 카드번호 보호를 위해 CVC번호는 별도로 제공되지 않습니다.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

            const Spacer(),

            /// 확인 버튼
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: authenticateAndShow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
