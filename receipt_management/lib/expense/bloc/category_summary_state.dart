import 'package:receipt_management/expense/models/category_summary_model.dart';

abstract class CategorySummaryState {}

class CategorySummaryInitial extends CategorySummaryState {}

class CategorySummaryLoaded extends CategorySummaryState {
  final FormattedCategorySummary summary;
  CategorySummaryLoaded({required this.summary});
}

class CategorySummaryLoading extends CategorySummaryState {}

class CategorySummaryFailed extends CategorySummaryState {
  final String errorMsg;

  CategorySummaryFailed({required this.errorMsg});
}

abstract class SingleCategorySummaryState {}

class SingleCategorySummaryInitial extends SingleCategorySummaryState {}

class SingleCategorySummaryLoaded extends SingleCategorySummaryState {
  final SingleCategorySummary summary;
  SingleCategorySummaryLoaded({required this.summary});
}

class SingleCategorySummaryLoading extends SingleCategorySummaryState {}

class SingleCategorySummaryFailed extends SingleCategorySummaryState {
  final String errorMsg;

  SingleCategorySummaryFailed({required this.errorMsg});
}

abstract class ReceiptsSummaryState {}

class ReceiptsSummaryInitial extends ReceiptsSummaryState {}

class ReceiptsSummaryLoaded extends ReceiptsSummaryState {}

class ReceiptsSummarySelected extends ReceiptsSummaryState {}

class ReceiptsSummaryCreated extends ReceiptsSummaryState {}

class ReceiptsSummaryFailed extends ReceiptsSummaryState {
  final String errorMsg;

  ReceiptsSummaryFailed({required this.errorMsg});
}
