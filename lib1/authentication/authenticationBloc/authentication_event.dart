import 'package:notado/packages/packages.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super();
}

class AppStarted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class LoggedOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
