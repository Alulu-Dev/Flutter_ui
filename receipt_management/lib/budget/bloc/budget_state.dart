import 'package:receipt_management/budget/models/budget_model.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetModel> budget;
  BudgetLoaded({required this.budget});
}

class BudgetFailed extends BudgetState {
  final String errorMsg;
  BudgetFailed({required this.errorMsg});
}

abstract class NewBudgetState {}

class NewBudgetInitial extends NewBudgetState {}

class NewBudgetLoaded extends NewBudgetState {
  final List<CategoryModel> categories;
  NewBudgetLoaded({required this.categories});
}

class NewBudgetSaved extends NewBudgetState {}

class NewBudgetFailed extends NewBudgetState {
  final String errorMsg;
  NewBudgetFailed({required this.errorMsg});
}
