class Member {
  final int? memberId;

  final String loginId;        // LOGIN_ID
  final String password;       // PASSWORD
  final String memberName;     // MEMBER_NAME
  final String lastNameEn;     // LAST_NAME_EN
  final String firstNameEn;    // FIRST_NAME_EN
  final DateTime birth;        // BIRTH
  final String rrn;            // RRN
  final String gender;         // GENDER (M/F)
  final String phoneNumber;    // PHONE_NUMBER
  final String mobileCarrier;  // MOBILE_CARRIER

  // 선택 정보
  final int? age;              // AGE
  final String? ageGroup;      // AGE_GROUP
  final String? email;         // EMAIL
  final String? postalCode;    // POSTAL_CODE
  final String? address;       // ADDRESS
  final String? addressDetail; // ADDRESS_DETAIL

  // 시스템 컬럼
  final DateTime? createdAt;   // CREATED_AT
  final String memberStatus;   // MEMBER_STATUS

  Member({
    this.memberId,
    required this.loginId,
    required this.password,
    required this.memberName,
    required this.lastNameEn,
    required this.firstNameEn,
    required this.birth,
    required this.rrn,
    required this.gender,
    required this.phoneNumber,
    required this.mobileCarrier,
    this.age,
    this.ageGroup,
    this.email,
    this.postalCode,
    this.address,
    this.addressDetail,
    this.createdAt,
    required this.memberStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'loginId': loginId,
      'password': password,
      'memberName': memberName,
      'lastNameEn': lastNameEn,
      'firstNameEn': firstNameEn,
      'birth': birth.toIso8601String(),
      'rrn': rrn,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'mobileCarrier': mobileCarrier,
      'age': age,
      'ageGroup': ageGroup,
      'email': email,
      'postalCode': postalCode,
      'address': address,
      'addressDetail': addressDetail,
      'createdAt': createdAt?.toIso8601String(),
      'memberStatus': memberStatus,
    };
  }
}
