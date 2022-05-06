import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/home/comparison/bloc/comparison_event.dart';
import 'package:receipt_management/home/comparison/bloc/comparison_state.dart';
import 'package:receipt_management/home/comparison/repository/comparison_repository.dart';

final ComparisonRepository _comparisonRepository = ComparisonRepository();

class ComparisonBloc extends Bloc<ComparisonEvent, ComparisonState> {
  ComparisonBloc() : super(ComparisonInitial()) {
    on<ComparisonLoad>(_onComparisonLoad);
    on<ComparisonUnload>(_onComparisonUnload);
  }

  Future<void> _onComparisonUnload(
      ComparisonUnload event, Emitter<ComparisonState> emit) async {
    emit(ComparisonInitial());
  }

  Future<void> _onComparisonLoad(
      ComparisonLoad event, Emitter<ComparisonState> emit) async {
    try {
      emit(ComparisonLoading());
      final _itemsList = await _comparisonRepository.userComparisonList();

      emit(ComparisonLoaded(itemsList: _itemsList));
    } catch (e) {
      emit(ComparisonFailed(errorMsg: "Failed to load list"));
    }
  }
}

class ComparisonDetailBloc
    extends Bloc<ComparisonDetailEvent, ComparisonDetailState> {
  ComparisonDetailBloc() : super(ComparisonDetailInitial()) {
    on<ComparisonDetailUnload>(_onComparisonDetailUnload);
    on<ComparisonDetailLoad>(_onComparisonDetailLoad);
    on<ComparisonDelete>(_onComparisonDelete);
    on<ComparisonDetailUpdate>(_onComparisonDetailUpdate);
  }
  Future<void> _onComparisonDetailUnload(
      ComparisonDetailUnload event, Emitter<ComparisonDetailState> emit) async {
    emit(ComparisonDetailInitial());
  }

  Future<void> _onComparisonDetailLoad(
      ComparisonDetailLoad event, Emitter<ComparisonDetailState> emit) async {
    try {
      emit(ComparisonDetailsLoading());
      final details =
          await _comparisonRepository.comparisonDetailRepository(event.id);
      emit(ComparisonDetailsLoaded(result: details));
    } catch (e) {
      emit(ComparisonDetailFailed(errorMsg: "Failed to load list"));
    }
  }

  Future<void> _onComparisonDelete(
      ComparisonDelete event, Emitter<ComparisonDetailState> emit) async {
    try {
      emit(ComparisonDetailsLoading());
      final _res = await _comparisonRepository.deleteComparison(event.id);
      print(_res);
      emit(ComparisonDeleted());
    } catch (e) {
      emit(ComparisonDetailFailed(errorMsg: "Failed to delete comparison"));
    }
  }

  Future<void> _onComparisonDetailUpdate(
      ComparisonDetailUpdate event, Emitter<ComparisonDetailState> emit) async {
    try {
      emit(ComparisonDetailsLoading());
      final details = await _comparisonRepository.updateComparison(event.id);
      emit(ComparisonDetailsLoaded(result: details));
    } catch (e) {
      emit(ComparisonDetailFailed(errorMsg: "Failed to create comparison"));
    }
  }
}

class ComparisonCreateBloc
    extends Bloc<ComparisonCreateEvent, ComparisonCreateState> {
  ComparisonCreateBloc() : super(ComparisonCreateInitial()) {
    on<ComparisonCreateLoad>(_onComparisonCreateLoad);
    on<ComparisonCreate>(_onComparisonCreate);
    on<ComparisonCreateUnload>(_onComparisonCreateUnLoad);
  }

  Future<void> _onComparisonCreateLoad(
      ComparisonCreateLoad event, Emitter<ComparisonCreateState> emit) async {
    try {
      final _itemsList = await _comparisonRepository.getComparableItems();
      emit(ComparisonCreateLoaded(items: _itemsList));
    } catch (e) {
      emit(ComparisonCreationFailed(errorMsg: e.toString()));
    }
  }

  Future<void> _onComparisonCreate(
      ComparisonCreate event, Emitter<ComparisonCreateState> emit) async {
    try {
      final _newComparison =
          await _comparisonRepository.createComparisonRepository(event.id);
      emit(ComparisonCreated(id: _newComparison));
    } catch (e) {
      emit(ComparisonCreationFailed(errorMsg: e.toString()));
    }
  }

  Future<void> _onComparisonCreateUnLoad(
      ComparisonCreateUnload event, Emitter<ComparisonCreateState> emit) async {
    try {
      emit(ComparisonCreateInitial());
    } catch (e) {
      emit(ComparisonCreationFailed(errorMsg: e.toString()));
    }
  }
}
