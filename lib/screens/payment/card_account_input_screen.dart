/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 계좌 등록 - 2

  - 선택한 카드 정보 불러오기
  - 계좌 입력 폼 (은행 선택, 계좌 번호 입력)
  - 입력 폼이 모두 작성되면, 하단 다음 버튼 활성화
  - 다음 버튼 누르면, 계좌 정보 임시 저장 (본인 인증 마칠 때까지)
  - 다음 버튼 클릭 시, 본인 인증 화면(card_account_verification_screen.dart)으로 이동

*/

import 'package:bnkpart2/screens/payment/card_account_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/dto/account_dto.dart';
import '../../providers/account_registration_provider.dart';

class CardAccountInputScreen extends StatelessWidget {
  final AccountInputDto selectedCard;

  const CardAccountInputScreen({super.key, required this.selectedCard});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountRegistrationProvider(),
      child: _CardAccountInputView(selectedCard: selectedCard),
    );
  }
}

class _CardAccountInputView extends StatelessWidget {
  const _CardAccountInputView({required this.selectedCard});

  final AccountInputDto selectedCard;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountRegistrationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // [수정] 계좌 등록 여부에 따라 다른 텍스트를 표시합니다.
            Text(
              selectedCard.bankName != "은행 정보 없음"
                  ? "변경하실 결제계좌를\n입력해주세요."
                  : "등록하실 결제계좌를\n입력해주세요.",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.4)
            ),
            const SizedBox(height: 30),
            _buildCardSummaryBox(),
            const SizedBox(height: 20),
            _buildInputForm(context),
            const SizedBox(height: 20),
            _buildAgreementSection(context),
            const Spacer(),
            _buildNextButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("결제계좌 등록", style: TextStyle(color: Colors.black, fontSize: 16)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ],
    );
  }

  Widget _buildCardSummaryBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(
            selectedCard.cardImageUrl,
            width: 60,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(child: Text("카드\n이미지", textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedCard.cardName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                selectedCard.bankName,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputForm(BuildContext context) {
    final provider = context.read<AccountRegistrationProvider>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("결제계좌", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: context.watch<AccountRegistrationProvider>().paymentBank,
            decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12), hintText: "은행·증권사 선택"),
            items: ["부산은행", "신한은행", "국민은행"].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
            onChanged: (val) {
              if (val != null) provider.setPaymentBank(val);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "'-'없이 입력", contentPadding: EdgeInsets.symmetric(horizontal: 12)),
            onChanged: (value) => provider.setPaymentAccountNumber(value),
          ),
          const SizedBox(height: 15),
          const Text("• 본인 명의의 계좌로만 변경 가능합니다.", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const Text("• 구.외환은행 계좌의 경우, 하나은행을 선택해 주세요.", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAgreementSection(BuildContext context) {
    final provider = context.watch<AccountRegistrationProvider>();
    final notifier = context.read<AccountRegistrationProvider>();
    return Column(
      children: [
        _buildAgreementRow(
          title: '[필수] 개인정보 수집 및 이용 동의',
          value: provider.agreedToPersonal,
          onChanged: (value) => notifier.setAgreement('personal', value ?? false),
          onTapDetail: () => _showTermsDialog(context, 'assets/terms/personal_info_agreement.txt'),
        ),
        _buildAgreementRow(
          title: '[필수] 제3자 정보 제공 동의',
          value: provider.agreedToThirdParty,
          onChanged: (value) => notifier.setAgreement('thirdParty', value ?? false),
          onTapDetail: () => _showTermsDialog(context, 'assets/terms/third_party_provision_agreement.txt'),
        ),
      ],
    );
  }

  Widget _buildAgreementRow({required String title, required bool value, required ValueChanged<bool?> onChanged, required VoidCallback onTapDetail}) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: Colors.black),
        Text(title, style: TextStyle(fontSize: 14)),
        const Spacer(),
        GestureDetector(
          onTap: onTapDetail,
          child: const Text("보기", style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline)),
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context, String path) async {
    final terms = await rootBundle.loadString(path);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("약관 상세"),
        content: SingleChildScrollView(child: Text(terms, style: const TextStyle(fontSize: 12))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인")),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final provider = context.watch<AccountRegistrationProvider>();
    final notifier = context.read<AccountRegistrationProvider>();

    final isInputValid = provider.paymentBank != null && (provider.paymentAccountNumber?.isNotEmpty ?? false);
    final allAgreed = provider.agreedToPersonal && provider.agreedToThirdParty;
    final isValid = isInputValid && allAgreed;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: (isValid && !provider.isLoading) ? () async {
          await notifier.requestVerificationCode();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CardAccountVerificationScreen(selectedCard: selectedCard),
            ),
          );
        } : null,
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: isValid ? Colors.black : Colors.grey.shade400, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: isValid ? Colors.red : Colors.grey.shade200,
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("다음", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
