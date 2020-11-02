import 'package:notado/packages/packages.dart';

import '../../../packages/packages.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchingData extends HomeEvent {}

class AddNewNote extends HomeEvent {}

class UpdateNewNote extends HomeEvent {}
