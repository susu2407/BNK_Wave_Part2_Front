/*
  날짜 : 2025-12-24
  이름 : 이수연
  내용 : 계좌 등록 - 3 (본인 인증)
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/account_registration_provider.dart';
import '../../models/dto/account_dto.dart';

class CardAccountVerificationScreen extends StatelessWidget {
  final AccountInputDto selectedCard;

  CardAccountVerificationScreen({super.key, required this.selectedCard});

  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountRegistrationProvider>();
    final notifier = context.read<AccountRegistrationProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('계좌 인증')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${provider.paymentBank ?? ""} 계좌로 1원을 보냈습니다.\n입금자명 뒤 숫자 4자리를 입력해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, letterSpacing: 10),
              decoration: InputDecoration(hintText: '1234', counterText: "", border: OutlineInputBorder()),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              // [수정] 비동기 처리를 위해 async 추가
              onPressed: provider.isLoading ? null : () async {
                final userInput = _codeController.text;
                if (userInput.length == 4) {
                  bool success = notifier.submitVerificationCode(userInput);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증 성공! 계좌를 등록합니다.')));
                    
                    // [수정] 최종 계좌 등록 함수 호출
                    final bool registerSuccess = await notifier.registerAccount();

                    // context.mounted는 비동기 작업 후 위젯이 여전히 화면에 있는지 확인 (필수)
                    if (context.mounted) {
                      if (registerSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 등록 절차가 완료되었습니다.')));
                        // [수정] 모든 스택을 제거하고 첫 화면으로 이동
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('최종 등록에 실패했습니다. 다시 시도해주세요.')));
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('인증번호가 일치하지 않습니다.')));
                  }
                }
              },
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15)),
              child: provider.isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('확인', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
