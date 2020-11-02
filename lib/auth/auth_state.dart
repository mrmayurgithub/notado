part of 'auth_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();
}

class UninitializedAuth extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticatedAuth extends AuthenticationState {
  final user = FirebaseAuth.instance.currentUser();
  @override
  List<Object> get props => [];
}

class UnauthenticatedAuth extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthInProgress extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthFailure extends AuthenticationState {
  final String message;
  AuthFailure({this.message});

  @override
  List<Object> get props => [message];
}
