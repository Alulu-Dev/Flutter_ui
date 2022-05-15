import 'package:receipt_management/home/wallet/Models/receipt_model.dart';
import 'package:receipt_management/home/wallet/Models/wallet_model.dart';

// wallet state
abstract class WalletState {}

class WalletUnloaded extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<WalletModel> receipts;

  WalletLoaded({
    required this.receipts,
  });
}

class WalletFailed extends WalletState {
  final String errorMsg;

  WalletFailed({required this.errorMsg});
}

// receipt state
abstract class ReceiptState {}

class ReceiptUnloaded extends ReceiptState {}

class ReceiptLoading extends ReceiptState {}

class ReceiptLoaded extends ReceiptState {
  final ReceiptModel receipt;

  ReceiptLoaded({required this.receipt});
}

class ReceiptDeleted extends ReceiptState {}

class ReceiptFailed extends ReceiptState {
  final String errorMsg;

  ReceiptFailed({required this.errorMsg});
}

// request state
abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestSent extends RequestState {}

class RequestUnsent extends RequestState {}

class ReceiptVerified extends RequestState {}

class RequestFailed extends RequestState {
  final String errorMsg;

  RequestFailed({required this.errorMsg});
}
