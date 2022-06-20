import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/budget/bloc/budget_event.dart';
import 'package:receipt_management/budget/bloc/budget_state.dart';
import 'package:receipt_management/budget/repository/budget_repository.dart';

final BudgetRepository budgetRepository = BudgetRepository();

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<BudgetUnload>((event, emit) {
      emit(BudgetInitial());
    });
    on<BudgetLoad>(_onBudgetLoadedLoad);
  }

  Future<void> _onBudgetLoadedLoad(
      BudgetLoad event, Emitter<BudgetState> emit) async {
    try {
      final _budget = await budgetRepository.allBudgets();
      emit(BudgetLoaded(budget: _budget));
    } catch (e) {
      // emit(BudgetFailed(errorMsg: "No summary found"));
    }
  }
}

class NewBudgetBloc extends Bloc<NewBudgetEvent, NewBudgetState> {
  NewBudgetBloc() : super(NewBudgetInitial()) {
    on<NewBudgetUnload>((event, emit) {
      emit(NewBudgetInitial());
    });
    on<NewBudgetSave>(_onNewBudgetSave);
    on<NewBudgetLoad>(_onNewBudgetLoad);
  }

  Future<void> _onNewBudgetLoad(
      NewBudgetLoad event, Emitter<NewBudgetState> emit) async {
    try {
      final _res = await budgetRepository.getAllCategories();
      emit(NewBudgetLoaded(categories: _res));
    } catch (e) {
      emit(NewBudgetFailed(errorMsg: "No summary found"));
    }
  }

  Future<void> _onNewBudgetSave(
      NewBudgetSave event, Emitter<NewBudgetState> emit) async {
    try {
      await budgetRepository.setBudget(event.catId, event.amount);
      emit(NewBudgetSaved());
    } catch (e) {
      emit(NewBudgetFailed(errorMsg: "No summary found"));
    }
  }
}
