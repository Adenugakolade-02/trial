class UserData {
  String? id,
      firebaseUserId,
      firstName,
      lastName,
      email,
      phoneNumber,
      pin,
      authType,
      status,
      userType;
  num? walletBalance, totalIncome, totalWithdrawals;
  bool? acceptTerms;

  UserData.fromJson(Map<String, dynamic> data) {
    firebaseUserId = data['firebase_user_id'];
    id = data['_id'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    email = data['email'];
    phoneNumber = data['phone_number'];
    pin = data['pin'];
    walletBalance = data['wallet_balance'] ?? 0;
    totalIncome = data['total_income'] ?? 0;
    totalWithdrawals = data['total_withdrawals'] ?? 0;
    authType = data['auth_type']; // pin, biometrics
    acceptTerms = data['accept_terms_and_conditions'];
    status = data['status']; // pending, active, blocked
    userType = data['user_type'];
  }

  static Map<String, dynamic> toJson(UserData value) {
    return {
      'firebase_user_id': value.firebaseUserId,
      '_id': value.id,
      'first_name': value.firstName,
      'last_name': value.lastName,
      'email': value.email,
      'phone_number': value.phoneNumber,
      'pin': value.pin,
      'wallet_balance': value.walletBalance,
      'total_income': value.totalIncome,
      'total_withdrawals': value.totalWithdrawals,
      'auth_type': value.authType,
      'accept_terms_and_conditions': value.acceptTerms,
      'status': value.status,
      'user_type': value.userType,
    };
  }
}