import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RouterState extends Equatable {
  RouterState([List props = const []]) : super(props);
}

class InitialRouterState extends RouterState {}

class StateMain extends RouterState {}

class StateRec extends RouterState {}

class StateComparison extends RouterState {}

class StateTranslation extends RouterState {}

class StatePicImage extends RouterState {}

class StateHistory extends RouterState {}

class StateCamera extends RouterState {}

class StatePreview extends RouterState {}
