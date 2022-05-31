// wallet event
abstract class WalletEvent {}

class WalletLoad extends WalletEvent {}

class WalletUnload extends WalletEvent {}

// receipt event
abstract class ReceiptEvent {}

class ReceiptUnload extends ReceiptEvent {}

class ReceiptDelete extends ReceiptEvent {}

class ReceiptLoad extends ReceiptEvent {
  final String receiptID;

  ReceiptLoad({
    required this.receiptID,
  });
}

// request event
abstract class RequestEvent {}

class ReceiptVerify extends RequestEvent {
  final String receiptId;
  ReceiptVerify({required this.receiptId});
}

class RequestUnload extends RequestEvent {}

class ReceiptCheckStatus extends RequestEvent {
  final String receiptId;
  ReceiptCheckStatus({required this.receiptId});
}
