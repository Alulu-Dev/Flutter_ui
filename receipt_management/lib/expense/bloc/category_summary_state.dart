import 'package:flutter/material.dart';
import 'package:receipt_management/expense/models/category_summary_model.dart';
import 'package:receipt_management/expense/models/receipts_summary_model.dart';
import 'package:receipt_management/home/wallet/Models/wallet_model.dart';

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

// Receipt summary list part

abstract class ReceiptsSummaryListState {}

class ReceiptsSummaryListInitial extends ReceiptsSummaryListState {}

class ReceiptsSummaryListLoaded extends ReceiptsSummaryListState {
  List<ReceiptExpenseSummary> summaries;
  ReceiptsSummaryListLoaded({required this.summaries});
}

class ReceiptsSummaryListFailed extends ReceiptsSummaryListState {
  final String errorMsg;
  ReceiptsSummaryListFailed({required this.errorMsg});
}

// Receipt Summary Details part

abstract class ReceiptsSummaryDetailsState {}

class ReceiptsSummaryDetailsInitial extends ReceiptsSummaryDetailsState {}

class ReceiptsSummaryDetailsDeleted extends ReceiptsSummaryDetailsState {}

class ReceiptsSummaryDetailsLoaded extends ReceiptsSummaryDetailsState {
  final ReceiptExpenseSummaryDetails summaryDetails;

  ReceiptsSummaryDetailsLoaded({required this.summaryDetails});
}

class ReceiptsSummaryDetailsFailed extends ReceiptsSummaryDetailsState {
  final String errorMsg;
  ReceiptsSummaryDetailsFailed({required this.errorMsg});
}

// Receipt summary create  part
abstract class ReceiptsSummaryState {}

class ReceiptsSummaryInitial extends ReceiptsSummaryState {}

class ReceiptsSummaryLoaded extends ReceiptsSummaryState {}

class ReceiptsSummarySelected extends ReceiptsSummaryState {
  final List<WalletModel> receipt;
  ReceiptsSummarySelected({required this.receipt});
}

class ReceiptsSummaryCreated extends ReceiptsSummaryState {
  final String summaryId;
  ReceiptsSummaryCreated({required this.summaryId});
}

class ReceiptsSummaryFailed extends ReceiptsSummaryState {
  final String errorMsg;

  ReceiptsSummaryFailed({required this.errorMsg});
}
