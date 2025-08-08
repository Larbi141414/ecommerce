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
}
