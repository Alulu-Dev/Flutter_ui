abstract class ComparisonEvent {}

class ComparisonLoad extends ComparisonEvent {}

class ComparisonUnload extends ComparisonEvent {}

abstract class ComparisonDetailEvent {}

class ComparisonDelete extends ComparisonDetailEvent {
  final String id;
  ComparisonDelete({required this.id});
}

class ComparisonDetailLoad extends ComparisonDetailEvent {
  final String id;
  ComparisonDetailLoad({required this.id});
}

class ComparisonDetailUpdate extends ComparisonDetailEvent {
  final String id;
  ComparisonDetailUpdate({required this.id});
}

class ComparisonDetailUnload extends ComparisonDetailEvent {}

abstract class ComparisonCreateEvent {}

class ComparisonCreateUnload extends ComparisonCreateEvent {}

class ComparisonCreateLoad extends ComparisonCreateEvent {}

class ComparisonCreate extends ComparisonCreateEvent {
  final String id;
  ComparisonCreate({required this.id});
}
