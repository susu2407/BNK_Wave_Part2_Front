class Member {
  final String usid;
  final String pass;
  final String name;
  final String role;
  final String engLast;
  final String engFirst;
  final String engname;
  final String rrnFront;
  final String rrnBack;
  final String rrn;
  final String hp;
  final String email;
  final DateTime? birth;
  final int? age;
  final String? gender;
  final String? carrier;
  final String? zipCode;
  final String? address;
  final String? addressDetail;
  final bool hasAccount;
  final String? bank;
  final String? accountNo;

  Member({
    required this.usid,
    required this.pass,
    required this.name,
    required this.role,
    required this.engLast,
    required this.engFirst,
    required this.engname,
    required this.rrnFront,
    required this.rrnBack,
    required this.rrn,
    required this.hp,
    required this.email,
    this.birth,
    this.age,
    this.gender,
    this.carrier,
    this.zipCode,
    this.address,
    this.addressDetail,

    required this.hasAccount,
    this.bank,
    this.accountNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'usid': usid,
      'pass': pass,
      'name': name,
      'role': role,
      'engLast': engLast,
      'engFirst': engFirst,
      'engname': engname,
      'rrnFront': rrnFront,
      'rrnBack': rrnBack,
      'rrn': rrn,
      'hp': hp,
      'email': email,
      'birth': birth?.toIso8601String(),
      'age': age,
      'gender': gender,
      'carrier': carrier,
      'zipCode': zipCode,
      'address': address,
      'addressDetail': addressDetail,
      'hasAccount': hasAccount,
      'bank': bank,
      'accountNo': accountNo,
    };
  }
}
