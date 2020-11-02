import 'package:flutter/material.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/login/bloc.dart';
import 'package:notado/screens/login/login_form.dart';
import 'package:notado/user_repository/user_Repository.dart';

class LoginScreen extends StatefulWidget {
  //UserRepository object needed to pass it to LoginForm
  final UserRepository userRepository;

  const LoginScreen({Key key, @required this.userRepository}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    // Initializng _loginBloc
    _loginBloc = LoginBloc(userRepository: widget.userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<LoginBloc>(
        create: (BuildContext context) => _loginBloc,
        child: LoginForm(userRepository: widget.userRepository),
      ),
    );
  }
}
