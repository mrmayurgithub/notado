import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

// class LoginGoogleInProgress extends LoginState {}

class LoginForgetPassword extends LoginState {}

class LoginSuccess extends LoginState {}

// class LoginNeedsVerification extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure({this.message});

  @override
  List<Object> get props => [message];
}
