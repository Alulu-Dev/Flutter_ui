abstract class BudgetEvent {}

class BudgetLoad extends BudgetEvent {}

class BudgetUnload extends BudgetEvent {}

abstract class NewBudgetEvent {}

class NewBudgetLoad extends NewBudgetEvent {}

class NewBudgetUnload extends NewBudgetEvent {}

class NewBudgetSave extends NewBudgetEvent {
  final String catId;
  final String amount;
  NewBudgetSave({required this.catId, required this.amount});
}
