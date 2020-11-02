import 'package:notado/packages/packages.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// class LoginButtonPressed extends LoginEvent {
//   final String email;
//   final String password;
//   LoginButtonPressed({@required this.email, @required this.password})
//       : assert(email != null),
//         assert(password != null);

//   @override
//   List<Object> get props => [email, password];
// }

// class SubmitButtonPressed extends LoginEvent {
//   final String email;
//   final String password;
//   SubmitButtonPressed({@required this.email, @required this.password})
//       : assert(email != null),
//         assert(password != null);

//   @override
//   List<Object> get props => [email, password];
// }

// //TODO: Apply is verified
// class checkVerification extends LoginEvent {}

// // class NeedsVerification extends LoginEvent {}

// class ForgetPassword extends LoginEvent {}

class LoginWithGoogle extends LoginEvent {}

// TODO: Check Whether need to implement emailChanged and PasswordChanged or Not
