// import 'package:flutter/material.dart';
// import 'package:notado/login/loginBloc/login_bloc.dart';
// import 'package:notado/packages/packages.dart';
// import 'package:notado/screens/register/register_form.dart';
// // import 'package:notado/packages/packages.dart';
// import 'package:notado/user_repository/user_Repository.dart';

// class RegisterScreen extends StatefulWidget {
//   //UserRepository object needed to pass it to LoginForm
//   final UserRepository userRepository;

//   const RegisterScreen({Key key, @required this.userRepository})
//       : super(key: key);
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   LoginBloc _loginBloc;

//   @override
//   void initState() {
//     // Initializng _loginBloc
//     _loginBloc = LoginBloc(userRepository: widget.userRepository);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocProvider<LoginBloc>(
//         create: (BuildContext context) => _loginBloc,
//         child: RegisterForm(userRepository: widget.userRepository),
//       ),
//     );
//   }
// }
