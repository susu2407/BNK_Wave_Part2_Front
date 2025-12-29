import 'dart:developer';
import 'package:bnkpart2/main.dart';
import 'package:flutter/material.dart';

import '../../models/entity/member.dart';
import '../../services/member_service.dart';
import 'CardAccountRegisterPage_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /* ─────────────────────────────────
   * Form / Scroll
   * ───────────────────────────────── */
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  /* ─────────────────────────────────
   * 기본 정보
   * ───────────────────────────────── */
  final _nameController = TextEditingController();
  final _usidController = TextEditingController();
  final _pass1Controller = TextEditingController();
  final _pass2Controller = TextEditingController();

  /* ─────────────────────────────────
   * 영문 이름
   * ───────────────────────────────── */
  final _engLastNameController = TextEditingController();
  final _engFirstNameController = TextEditingController();

  /* ─────────────────────────────────
   * 주민등록번호
   * ───────────────────────────────── */
  final _rrnFrontController = TextEditingController();
  final _rrnBackController = TextEditingController();

  /* ─────────────────────────────────
   * 연락처
   * ───────────────────────────────── */
  final _hpController = TextEditingController();
  final _emailController = TextEditingController();

  /* ─────────────────────────────────
   * 추가 정보
   * ───────────────────────────────── */
  DateTime? _birthDate;
  final _ageController = TextEditingController();
  String _gender = 'M';

  // 통신사
  bool _carrierExpanded = false;
  String? _selectedCarrier;

  /* ─────────────────────────────────
   * 주소
   * ───────────────────────────────── */
  final _zipCodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressDetailController = TextEditingController();

  /* ─────────────────────────────────
   * 계좌
   * ───────────────────────────────── */
  bool _hasAccount = false;
  final _bankController = TextEditingController();
  final _accountController = TextEditingController();

  final List<String> carriers = [
    'KT',
    'SKT',
    'LGU',
    'KT알뜰폰',
    'SKT알뜰폰',
    'LGU알뜰폰',
  ];

  final _service = MemberService();

  /* ─────────────────────────────────
   * Submit
   * ───────────────────────────────── */
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final member = Member(
      usid: _usidController.text,
      pass: _pass1Controller.text,
      name: _nameController.text,
      role: 'USER',

      engLast: _engLastNameController.text,
      engFirst: _engFirstNameController.text,
      engname:
      '${_engLastNameController.text} ${_engFirstNameController.text}',

      rrnFront: _rrnFrontController.text,
      rrnBack: _rrnBackController.text,
      rrn: '${_rrnFrontController.text}-${_rrnBackController.text}',

      birth: _birthDate,
      age: int.tryParse(_ageController.text),
      gender: _gender,
      carrier: _selectedCarrier,

      zipCode: _zipCodeController.text,
      address: _addressController.text,
      addressDetail: _addressDetailController.text,

      hp: _hpController.text,
      email: _emailController.text,

      hasAccount: _hasAccount,
      bank: _hasAccount ? _bankController.text : null,
      accountNo: _hasAccount ? _accountController.text : null,
    );

    log('member json: ${member.toJson()}');

    try {
      await _service.register(member);
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('회원가입 완료')));

      if (!_hasAccount) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CardAccountRegisterPage()),
        );
        return;
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage(title: "BNK WAVE")),
            (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('에러 발생: $e')));
    }
  }

  /* ─────────────────────────────────
   * UI
   * ───────────────────────────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _sectionTitle('기본 정보'),
              _input(_nameController, '이름'),
              _input(_usidController, '아이디'),
              _input(_pass1Controller, '비밀번호', obscure: true),
              _input(_pass2Controller, '비밀번호 확인', obscure: true),

              _sectionTitle('영문 이름'),
              _input(_engLastNameController, '영문 성'),
              _input(_engFirstNameController, '영문 이름'),

              _sectionTitle('주민등록번호'),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _input(
                      _rrnFrontController,
                      '앞 6자리',
                      keyboard: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: _input(
                      _rrnBackController,
                      '뒤 7자리',
                      keyboard: TextInputType.number,
                      obscure: true,
                    ),
                  ),
                ],
              ),

              _sectionTitle('연락처'),
              _carrierSelector(), // ✅ 통신사 위치 이동
              _input(_hpController, '휴대폰 번호'),
              _input(_emailController, '이메일'),

              _sectionTitle('추가 정보'),
              _birthPicker(),
              _input(_ageController, '나이',
                  keyboard: TextInputType.number),
              _genderDropdown(),

              _sectionTitle('주소'),
              _input(_zipCodeController, '우편번호'),
              _input(_addressController, '주소'),
              _input(_addressDetailController, '상세주소'),

              _sectionTitle('계좌 정보'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('계좌 보유'),
                value: _hasAccount,
                onChanged: (v) => setState(() => _hasAccount = v),
              ),
              if (_hasAccount) ...[
                _input(_bankController, '은행명'),
                _input(_accountController, '계좌번호'),
              ],

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('가입'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ─────────────────────────────────
   * Components
   * ───────────────────────────────── */
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _input(
      TextEditingController controller,
      String label, {
        bool obscure = false,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
        v == null || v.isEmpty ? '$label 입력 필수' : null,
      ),
    );
  }

  Widget _birthPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('생년월일'),
        const SizedBox(height: 5),
        InkWell(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (d != null) setState(() => _birthDate = d);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: const OutlineInputBorder(),
            ),
            child: Text(
              _birthDate == null
                  ? '선택'
                  : '${_birthDate!.year}-${_birthDate!.month}-${_birthDate!.day}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: const InputDecoration(labelText: '성별'),
      items: const [
        DropdownMenuItem(value: 'M', child: Text('남')),
        DropdownMenuItem(value: 'F', child: Text('여')),
      ],
      onChanged: (v) => setState(() => _gender = v!),
    );
  }

  Widget _carrierSelector() {
    return Column(
      children: [
        InkWell(
          onTap: () =>
              setState(() => _carrierExpanded = !_carrierExpanded),
          child: InputDecorator(
            decoration:
            const InputDecoration(labelText: '통신사'),
            child: Text(_selectedCarrier ?? '선택'),
          ),
        ),
        if (_carrierExpanded)
          ...carriers.map((c) => ListTile(
            title: Text(c),
            onTap: () {
              setState(() {
                _selectedCarrier = c;
                _carrierExpanded = false;
              });
            },
          )),
      ],
    );
  }

  /* ─────────────────────────────────
   * Dispose
   * ───────────────────────────────── */
  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _usidController.dispose();
    _pass1Controller.dispose();
    _pass2Controller.dispose();
    _engLastNameController.dispose();
    _engFirstNameController.dispose();
    _rrnFrontController.dispose();
    _rrnBackController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _zipCodeController.dispose();
    _addressController.dispose();
    _addressDetailController.dispose();
    _bankController.dispose();
    _accountController.dispose();
    super.dispose();
  }
}
