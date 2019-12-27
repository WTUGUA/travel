import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HistoryState extends Equatable {
  HistoryState([List props = const []]) : super(props);
}

class InitialHistoryState extends HistoryState {}
