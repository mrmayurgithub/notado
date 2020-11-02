import 'package:notado/packages/packages.dart';

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
  List<Object> get props => [];
}
