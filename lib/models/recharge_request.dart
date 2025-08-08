class RechargeRequest {
  final String id;
  final String userId;
  final double amount;
  final String receiptImagePath;

  RechargeRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.receiptImagePath,
  });

  // تحويل الكائن إلى Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'receiptImagePath': receiptImagePath,
    };
  }

  // إنشاء كائن من Map
  factory RechargeRequest.fromMap(Map<String, dynamic> map) {
    return RechargeRequest(
      id: map['id'],
      userId: map['userId'],
      amount: (map['amount'] ?? 0).toDouble(),
      receiptImagePath: map['receiptImagePath'],
    );
  }
}
