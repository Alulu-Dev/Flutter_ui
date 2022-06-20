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
    on<ReceiptsSummarySelect>(_onReceiptsSummarySelect);
    on<ReceiptsSummaryCreate>(_onReceiptsSummaryCreate);
  }

  Future<void> _onReceiptsSummaryLoad(
      ReceiptsSummaryLoad event, Emitter<ReceiptsSummaryState> emit) async {
    emit(ReceiptsSummaryLoaded());
  }

  Future<void> _onReceiptsSummaryUnload(
      ReceiptsSummaryUnload event, Emitter<ReceiptsSummaryState> emit) async {
    emit(ReceiptsSummaryInitial());
  }

  Future<void> _onReceiptsSummarySelect(
      ReceiptsSummarySelect event, Emitter<ReceiptsSummaryState> emit) async {
    emit(ReceiptsSummarySelected(receipt: event.receipts));
  }

  Future<void> _onReceiptsSummaryCreate(
      ReceiptsSummaryCreate event, Emitter<ReceiptsSummaryState> emit) async {
    try {
      final response = await categorySummaryRepository.createSummary(
          event.title, event.note, event.receiptsId);
      emit(ReceiptsSummaryCreated(summaryId: response));
    } catch (e) {
      emit(ReceiptsSummaryFailed(errorMsg: e.toString()));
    }
  }
}

class ReceiptsSummaryListBloc
    extends Bloc<ReceiptsSummaryListEvent, ReceiptsSummaryListState> {
  ReceiptsSummaryListBloc() : super(ReceiptsSummaryListInitial()) {
    on<ReceiptSummaryUnload>(_onReceiptsSummaryListUnload);
    on<ReceiptSummaryLoad>(_onReceiptsSummaryListLoad);
  }

  Future<void> _onReceiptsSummaryListUnload(ReceiptSummaryUnload event,
      Emitter<ReceiptsSummaryListState> emit) async {
    emit(ReceiptsSummaryListInitial());
  }

  Future<void> _onReceiptsSummaryListLoad(
      ReceiptSummaryLoad event, Emitter<ReceiptsSummaryListState> emit) async {
    try {
      final summaries = await categorySummaryRepository.allReceiptSummaries();
      emit(ReceiptsSummaryListLoaded(summaries: summaries));
    } on Exception catch (e) {
      emit(ReceiptsSummaryListFailed(errorMsg: e.toString()));
    }
  }
}

class ReceiptsSummaryDetailsBloc
    extends Bloc<ReceiptsSummaryDetailsEvent, ReceiptsSummaryDetailsState> {
  ReceiptsSummaryDetailsBloc() : super(ReceiptsSummaryDetailsInitial()) {
    on<ReceiptsSummaryDetailsUnload>(_onReceiptsSummaryDetailsUnload);
    on<ReceiptsSummaryDetailsLoad>(_onReceiptsSummaryDetailsLoad);
    on<ReceiptsSummaryDetailsDelete>(_onReceiptsSummaryDetailsDelete);
    on<ReceiptsSummaryDetailsUpdate>(_onReceiptsSummaryDetailsUpdate);
  }

  Future<void> _onReceiptsSummaryDetailsUnload(
      ReceiptsSummaryDetailsUnload event,
      Emitter<ReceiptsSummaryDetailsState> emit) async {
    emit(ReceiptsSummaryDetailsInitial());
  }

  Future<void> _onReceiptsSummaryDetailsLoad(ReceiptsSummaryDetailsLoad event,
      Emitter<ReceiptsSummaryDetailsState> emit) async {
    final summary =
        await categorySummaryRepository.receiptSummary(event.summaryId);

    emit(ReceiptsSummaryDetailsLoaded(summaryDetails: summary));
  }

  Future<void> _onReceiptsSummaryDetailsDelete(
      ReceiptsSummaryDetailsDelete event,
      Emitter<ReceiptsSummaryDetailsState> emit) async {
    try {
      await categorySummaryRepository.deleteReceiptSummary(event.summaryId);
      emit(ReceiptsSummaryDetailsDeleted());
    } catch (e) {
      emit(ReceiptsSummaryDetailsFailed(errorMsg: e.toString()));
    }
  }

  Future<void> _onReceiptsSummaryDetailsUpdate(
      ReceiptsSummaryDetailsUpdate event,
      Emitter<ReceiptsSummaryDetailsState> emit) async {}
}
