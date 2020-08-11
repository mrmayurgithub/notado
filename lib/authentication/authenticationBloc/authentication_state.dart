import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();
}

class Uninitialized extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  final user = FirebaseAuth.instance.currentUser();
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthenticationState {
  @override
  List<Object> get props => throw UnimplementedError();
}
