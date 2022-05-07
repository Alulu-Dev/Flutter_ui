import 'package:receipt_management/home/comparison/models/comparison_models.dart';

abstract class ComparisonState {}

class ComparisonInitial extends ComparisonState {}

class ComparisonLoaded extends ComparisonState {
  final List<ComparisonModel> itemsList;
  ComparisonLoaded({required this.itemsList});
}

class ComparisonLoading extends ComparisonState {}

class ComparisonFailed extends ComparisonState {
  final String errorMsg;
  ComparisonFailed({required this.errorMsg});
}

abstract class ComparisonDetailState {}

class ComparisonDetailInitial extends ComparisonDetailState {}

class ComparisonDetailsLoaded extends ComparisonDetailState {
  final ComparisonDetailModel result;
  ComparisonDetailsLoaded({required this.result});
}

class ComparisonDetailsLoading extends ComparisonDetailState {}

class ComparisonDeleted extends ComparisonDetailState {}

class ComparisonDetailFailed extends ComparisonDetailState {
  final String errorMsg;
  ComparisonDetailFailed({required this.errorMsg});
}

abstract class ComparisonCreateState {}

class ComparisonCreateInitial extends ComparisonCreateState {}

class ComparisonCreateLoaded extends ComparisonCreateState {
  final List<ComparableItemsModel> items;
  ComparisonCreateLoaded({required this.items});
}

class ComparisonCreated extends ComparisonCreateState {
  final String id;
  ComparisonCreated({required this.id});
}

class ComparisonCreationFailed extends ComparisonCreateState {
  final String errorMsg;
  ComparisonCreationFailed({required this.errorMsg});
}
