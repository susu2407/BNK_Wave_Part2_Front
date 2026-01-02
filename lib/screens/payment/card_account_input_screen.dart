/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 계좌 등록 - 2 (단일 화면 흐름 적용)
*/

import 'package:bnkpart2/screens/payment/card_account_result_screen.dart';
import 'package:bnkpart2/screens/payment/card_list_item_widget.dart';
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

  static final TextEditingController _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountRegistrationProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    selectedCard.bankName != null
                        ? "변경하실 결제계좌를\n입력해주세요."
                        : "등록하실 결제계좌를\n입력해주세요.",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.4)
                  ),
                  const SizedBox(height: 30),
                  CardListItemWidget(
                    cardName: selectedCard.cardName,
                    cardType: selectedCard.cardType,
                    cardNumber: selectedCard.cardNumber,
                    paymentBank: selectedCard.bankName,
                    paymentAccount: selectedCard.paymentAccount,
                    cardImageUrl: selectedCard.cardImageUrl,
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  _buildInputForm(context),
                  const SizedBox(height: 10),
                  _buildAgreementSection(context),
                  if (provider.isVerificationRequested)
                    _buildVerificationForm(context),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          _buildNextButton(context),
        ],
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
        ],
      ),
    );
  }

  Widget _buildVerificationForm(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("인증번호", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          TextField(
            controller: _verificationCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "계좌에 입금된 숫자 4자리", contentPadding: EdgeInsets.symmetric(horizontal: 12)),
          ),
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
        GestureDetector(
          onTap: () => onChanged(!value),
          behavior: HitTestBehavior.translucent,
          child: Row(
            children: [
              Checkbox(value: value, onChanged: onChanged, activeColor: Colors.black),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTapDetail,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text("보기", style: TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.underline)),
          ),
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
    final isRequestValid = isInputValid && allAgreed;
    final isSubmitValid = _verificationCodeController.text.length == 4;

    final bool isVerificationMode = provider.isVerificationRequested;
    final String buttonText = isVerificationMode ? '확인 및 등록' : '인증번호 요청';
    final bool isButtonEnabled = isVerificationMode ? isSubmitValid : isRequestValid;

    return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
        child: SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: (isButtonEnabled && !provider.isLoading) ? () async {
                if (isVerificationMode) {
                  final success = await notifier.submitAndRegister(_verificationCodeController.text);
                  if (context.mounted && success) {
                    // [수정] 결과 화면으로 이동
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => CardAccountResultScreen(
                          registeredCardInfo: selectedCard,
                          newBankName: provider.paymentBank!,
                          newAccountNumber: provider.paymentAccountNumber!,
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                    // [추가] 등록 성공 후 컨트롤러의 텍스트를 깨끗하게 비웁니다.
                    _verificationCodeController.clear();
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('인증번호가 일치하지 않습니다.')));
                  }
                } else {
                  await notifier.requestVerification();
                }
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCB2B11),
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(buttonText,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                )
              ),
            ),
        ),
    );
  }
}
