abstract class CategorySummaryEvent {}

class CategorySummaryLoad extends CategorySummaryEvent {}

class CategorySummaryUnload extends CategorySummaryEvent {}

abstract class SingleCategorySummaryEvent {}

class SingleCategorySummaryLoad extends SingleCategorySummaryEvent {
  final String catId;
  SingleCategorySummaryLoad({required this.catId});
}

class SingleCategorySummaryUnload extends SingleCategorySummaryEvent {}

abstract class ReceiptsSummaryEvent {}

class ReceiptsSummaryUnload extends ReceiptsSummaryEvent {}

class ReceiptsSummaryLoad extends ReceiptsSummaryEvent {}

class ReceiptsSummarySelect extends ReceiptsSummaryEvent {}

class ReceiptsSummaryCreate extends ReceiptsSummaryEvent {}
