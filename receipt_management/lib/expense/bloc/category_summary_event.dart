import 'package:receipt_management/home/wallet/Models/wallet_model.dart';

abstract class CategorySummaryEvent {}

class CategorySummaryLoad extends CategorySummaryEvent {}

class CategorySummaryUnload extends CategorySummaryEvent {}

abstract class SingleCategorySummaryEvent {}

class SingleCategorySummaryLoad extends SingleCategorySummaryEvent {
  final String catId;
  SingleCategorySummaryLoad({required this.catId});
}

class SingleCategorySummaryUnload extends SingleCategorySummaryEvent {}

// summary for selected receipts
abstract class ReceiptsSummaryEvent {}

class ReceiptsSummaryUnload extends ReceiptsSummaryEvent {}

class ReceiptsSummaryLoad extends ReceiptsSummaryEvent {}

class ReceiptsSummarySelect extends ReceiptsSummaryEvent {
  final List<WalletModel> receipts;
  ReceiptsSummarySelect({required this.receipts});
}

class ReceiptsSummaryCreate extends ReceiptsSummaryEvent {
  final String title;
  final String note;
  final List<Map> receiptsId;

  ReceiptsSummaryCreate({
    required this.title,
    required this.note,
    required this.receiptsId,
  });
}

// receipt summary list part

abstract class ReceiptsSummaryListEvent {}

class ReceiptSummaryLoad extends ReceiptsSummaryListEvent {}

class ReceiptSummaryUnload extends ReceiptsSummaryListEvent {}

// receipt summary details part

abstract class ReceiptsSummaryDetailsEvent {}

class ReceiptsSummaryDetailsLoad extends ReceiptsSummaryDetailsEvent {
  final String summaryId;
  ReceiptsSummaryDetailsLoad({required this.summaryId});
}

class ReceiptsSummaryDetailsUnload extends ReceiptsSummaryDetailsEvent {}

class ReceiptsSummaryDetailsDelete extends ReceiptsSummaryDetailsEvent {
  final String summaryId;
  ReceiptsSummaryDetailsDelete({required this.summaryId});
}

class ReceiptsSummaryDetailsUpdate extends ReceiptsSummaryDetailsEvent {}
