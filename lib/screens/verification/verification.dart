import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notado/authentication/authenticationBloc/authentication_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/login/bloc.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'package:notado/screens/home/list_page.dart';

class VerificationScreen extends StatefulWidget {
  final UserRepository userRepository;

  const VerificationScreen({Key key, @required this.userRepository})
      : super(key: key);
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
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
      body: BlocProvider<LoginBloc>(
        create: (BuildContext context) => _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          cubit: _loginBloc,
          listener: (BuildContext context, state) {
            if (state is RegistrationProgress) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 440),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var curve = Curves.easeInOutQuad;
                    var tween = Tween(begin: 0.0, end: 1.0)
                        .chain(CurveTween(curve: curve));
                    return FadeTransition(
                      opacity: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
              // Scaffold.of(context).showSnackBar(
              //   SnackBar(
              //     backgroundColor: Colors.transparent,
              //     content: AlertDialog(
              //       elevation: 0.0,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(0)),
              //       backgroundColor: Colors.transparent,
              //       content: CircularProgressIndicator(),
              //     ),
              //   ),
              // );
            } else if (state is RegistrationSuccess) {
              // BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              //TODO: check it
              // Navigator.pushReplacementNamed(context, './HomeScreen');
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return BlocProvider.value(
                    value: _loginBloc,
                    child: HomeScreen(userRepository: widget.userRepository));
              }));
            } else if (state is VerificationFailure) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 30),
                    content: Row(
                      children: [
                        Text('Verification Failure'),
                        Icon(Icons.error),
                      ],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            // else if (state is NotVerified) {}
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            cubit: _loginBloc,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        // width: MediaQuery.of(context).size.width / 2,
                        child: Center(
                          child: Text(
                            'Please verify your email...',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(checkVerification());
                        },
                        child: Text('Done'),
                      ),
                      SizedBox(height: 10),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          widget.userRepository.sendVerificationEmail();
                        },
                        child: Text('Send verification link again'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
