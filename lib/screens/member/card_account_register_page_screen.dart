import 'package:flutter/material.dart';

class CardAccountRegisterPage extends StatefulWidget {
  const CardAccountRegisterPage({super.key});

  @override
  State<CardAccountRegisterPage> createState() =>
      _CardAccountRegisterPageState();
}

class _CardAccountRegisterPageState extends State<CardAccountRegisterPage> {
  final TextEditingController _accountController = TextEditingController();

  String? selectedBank;

  final List<String> banks = [
    '부산은행',
    '카카오뱅크',
    '국민은행',
    '신한은행',
    '우리은행',
    '하나은행',
    '농협은행',
  ];

  /// 계좌번호 유효성 검사 (숫자 10~14자리)
  bool isValidAccountNumber(String value) {
    if (value.isEmpty) return false;
    final regex = RegExp(r'^[0-9]{10,14}$');
    return regex.hasMatch(value);
  }

  /// 다음 버튼 활성 조건
  bool get isNextEnabled {
    return selectedBank != null &&
        isValidAccountNumber(_accountController.text);
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '결제계좌 등록',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 안내 문구
              const Text(
                '등록하실 결제계좌를\n입력해주세요.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              /// 카드 정보 영역
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.credit_card),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '드림',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '카카오뱅크 개인사업자카드',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 결제계좌 입력 영역
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '결제계좌',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    /// 은행 선택
                    DropdownButtonFormField<String>(
                      value: selectedBank,
                      hint: const Text('은행 · 증권사 선택'),
                      items: banks
                          .map(
                            (bank) => DropdownMenuItem(
                          value: bank,
                          child: Text(bank),
                        ),
                      )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBank = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 계좌번호 입력
                    TextField(
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: '-없이 입력',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        errorText: _accountController.text.isEmpty
                            ? null
                            : isValidAccountNumber(
                            _accountController.text)
                            ? null
                            : '계좌번호를 정확히 입력해주세요',
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      '· 본인 명의의 계좌만 연결 가능합니다.\n'
                          '· 주 거래은행 계좌 등록을 추천드립니다.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// 다음 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isNextEnabled
                      ? () {
                    // TODO: API 호출 후 다음 화면 이동
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isNextEnabled ? Colors.black : Colors.grey.shade300,
                    foregroundColor:
                    isNextEnabled ? Colors.white : Colors.black,
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
