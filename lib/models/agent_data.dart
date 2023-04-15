class AgentData {
  String? id,
      firebaseUserId,
      firstName,
      lastName,
      email,
      phoneNumber,
      pin,
      authType,
      status,
      userType,
      securityQuestion,
      securityAnswer;
  num? walletBalance, totalIncome, totalWithdrawals;
  bool? acceptTerms;

  AgentData.fromJson(Map<String, dynamic> data) {
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
    securityQuestion = data['security_question'];
    securityAnswer = data['security_answer'];
  }
}