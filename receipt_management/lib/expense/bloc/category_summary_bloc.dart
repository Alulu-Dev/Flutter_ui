import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:receipt_management/expense/bloc/category_summary_event.dart';
import 'package:receipt_management/expense/bloc/category_summary_state.dart';
import 'package:receipt_management/expense/repository/category_summary_repository.dart';

final CategorySummaryRepository categorySummaryRepository =
    CategorySummaryRepository();

class CategorySummaryBloc
    extends Bloc<CategorySummaryEvent, CategorySummaryState> {
  CategorySummaryBloc() : super(CategorySummaryInitial()) {
    on<CategorySummaryUnload>((event, emit) {
      emit(CategorySummaryInitial());
    });
    on<CategorySummaryLoad>(_onCategorySummaryLoad);
  }

  Future<void> _onCategorySummaryLoad(
      CategorySummaryLoad event, Emitter<CategorySummaryState> emit) async {
    try {
      final _summary = await categorySummaryRepository.allCategorySummary();
      emit(CategorySummaryLoaded(summary: _summary));
    } catch (e) {
      emit(CategorySummaryFailed(errorMsg: "No summary found"));
    }
  }
}

class SingleCategorySummaryBloc
    extends Bloc<SingleCategorySummaryEvent, SingleCategorySummaryState> {
  SingleCategorySummaryBloc() : super(SingleCategorySummaryInitial()) {
    on<SingleCategorySummaryUnload>((event, emit) {
      emit(SingleCategorySummaryInitial());
    });
    on<SingleCategorySummaryLoad>(_onSingleCategorySummaryLoad);
  }

  Future<void> _onSingleCategorySummaryLoad(SingleCategorySummaryLoad event,
      Emitter<SingleCategorySummaryState> emit) async {
    try {
      final _summary =
          await categorySummaryRepository.singleCategorySummary(event.catId);
      emit(SingleCategorySummaryLoaded(summary: _summary));
    } catch (e) {
      emit(SingleCategorySummaryFailed(errorMsg: "No summary found"));
    }
  }
}

class ReceiptsSummaryBloc
    extends Bloc<ReceiptsSummaryEvent, ReceiptsSummaryState> {
  ReceiptsSummaryBloc() : super(ReceiptsSummaryInitial()) {
    on<ReceiptsSummaryLoad>(_onReceiptsSummaryLoad);
    on<ReceiptsSummaryUnload>(_onReceiptsSummaryUnload);
  }

  Future<void> _onReceiptsSummaryLoad(
      ReceiptsSummaryLoad event, Emitter<ReceiptsSummaryState> emit) async {
    emit(ReceiptsSummaryLoaded());
  }

  Future<void> _onReceiptsSummaryUnload(
      ReceiptsSummaryUnload event, Emitter<ReceiptsSummaryState> emit) async {
    emit(ReceiptsSummaryInitial());
  }
}
