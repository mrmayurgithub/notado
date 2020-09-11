import 'package:flutter/material.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/authentication/authentication_bloc.dart';
import 'package:notado/constants/constants.dart';
import 'package:notado/login/bloc.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/screens/home/home_splash.dart';
import 'package:notado/screens/home/list_page.dart';
import 'package:notado/screens/login/circular_progress.dart';
import 'package:notado/screens/register/register_screen.dart';
import 'package:notado/screens/verification/verification.dart';
import 'package:notado/user_repository/user_Repository.dart';

class LoginForm extends StatefulWidget {
  final UserRepository userRepository;

  const LoginForm({Key key, @required this.userRepository}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // ignore: unused_field
  final TextEditingController _emailController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field
  LoginBloc _loginBloc;
  bool isPassValid = false;
  bool isEmailValid = false;
  bool isPassVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    //  Closing the _loginBloc instance
    // _loginBloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = 1001.0694778740428;
    final w = 462.03206671109666;
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final buttonHeight = 58.61497099300238 / h;
    final buttonWidth = (w - MediaQuery.of(context).size.width / 4.5) /
        w; //350.02137780739776 / w;
    final topPad = 120 / h;
    final loginScreentextPadH = 8 / h;
    final loginScreentextPadV = 8 / w;
    final mainColumnPadding = 25 / w;
    final fieldPad = 23 / h;

    return BlocListener<LoginBloc, LoginState>(
      cubit: _loginBloc,
      listener: (BuildContext context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        } else if (state is NotVerified) {
          //TODO: Add verification code
          //TODO: Add navigation to another screen that shows email is not verified
/*********************************************************************************** */
          //This should be shown on Registration Screen
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: AlertDialog(
                content: Column(
                  children: <Widget>[
                    Text('Please Verify your email'),
                    GestureDetector(
                      onTap: () => BlocProvider.of<LoginBloc>(context)
                          .add(checkVerification()),
                      child: Text('Done', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is VerificationFailure) {
          // Add code
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Verification Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        } else if (state is LoginSuccess) {
          print("Login success state");
          // return BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                // return HomeSplash(userRepository: widget.userRepository);
                return HomeScreen(userRepository: widget.userRepository);
              },
            ),
          );
        } else if (state is LoginInProgress) {
          // Scaffold.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     SnackBar(
          //       content: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text('Logging In...'),
          //           CircularProgressIndicator(),
          //         ],
          //       ),
          //     ),
          //   );

          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return CircularProgress();
          }));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        cubit: _loginBloc,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(mainColumnPadding * width),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome Text widget
                  WelcomeText(fieldPad: 18 / h, height: height),
                  SizedBox(height: fieldPad * height),
                  // TextField for email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,

                    // autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      //validating email
                      return _emailController.text.contains("@")
                          ? null
                          : 'Invalid Email';
                    },
                    decoration: inputDecorationEmail(),
                  ),
                  SizedBox(height: fieldPad * height),
                  //TextField for password
                  TextFormField(
                    obscureText: !isPassVisible,
                    // autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      //validating password
                      return _passwordController.text.length < 6
                          ? 'Your password should have atleast 6 characters'
                          : null;
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPassVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPassVisible = !isPassVisible;
                          });
                        },
                      ),
                      // errorText:
                      //     _emailController.text.contains('@') ? null : 'Enter a correct email',
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: 'Password',
                      hintStyle: hintStyle(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(loginPageRadius),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(loginPageRadius),
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(loginPageRadius),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: fieldPad * height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {},
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fieldPad * height),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: fieldPad * height),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          //Adding event to SubmitButtonPressed
                          onTap: () {
                            //TODO: Check is it correct or not
                            if (_formKey.currentState.validate()) {
                              // The code below was for creating an account
                              // BlocProvider.of<LoginBloc>(context).add(
                              //   SubmitButtonPressed(
                              //     email: _emailController.text,
                              //     password: _passwordController.text,
                              //   ),);
                              //
                              // Adding event LoginButtonPressed to iniitiate login
                              //
                              BlocProvider.of<LoginBloc>(context).add(
                                LoginButtonPressed(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                            } else {
                              //TODO: Implement else function
                              print(
                                  '..........................------------------');
                            }
                          },
                          child: LoginButton(
                            buttonHeight: buttonHeight,
                            height: height,
                            buttonWidth: buttonWidth,
                            width: width,
                            loginScreentextPadV: loginScreentextPadV,
                            loginScreentextPadH: loginScreentextPadH,
                          ),
                        ),
                        SizedBox(height: fieldPad * height),
                        GestureDetector(
                          onTap: () => {
                            //Added event LoginWithGoogle
                            BlocProvider.of<LoginBloc>(context)
                                .add(LoginWithGoogle()),
                          },
                          child: GoogleSigninButton(
                            buttonHeight: buttonHeight,
                            height: height,
                            buttonWidth: buttonWidth,
                            width: width,
                            loginScreentextPadV: loginScreentextPadV,
                            loginScreentextPadH: loginScreentextPadH,
                          ),
                        ),
                        SizedBox(height: fieldPad * height),
                        // Create Account button
                        CreateAccountButton(widget: widget),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration inputDecorationEmail() {
    return InputDecoration(
      // errorText:
      //     _emailController.text.contains('@') ? null : 'Enter a correct email',
      prefixIcon: Icon(Icons.mail_outline, size: 27),
      hintText: 'Email',
      hintStyle: hintStyle(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(loginPageRadius),
        borderSide: BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(loginPageRadius),
        borderSide: BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(loginPageRadius),
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  TextStyle hintStyle() {
    return TextStyle(
        color: Colors.black54, fontWeight: FontWeight.w300, fontSize: 16);
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final LoginForm widget;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an Account'),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return RegisterScreen(userRepository: widget.userRepository);
            },
          ),
        );

        // Navigator.pushReplacementNamed(context, './RegisterScreen');
      },
    );
  }
}

class GoogleSigninButton extends StatelessWidget {
  const GoogleSigninButton({
    Key key,
    @required this.buttonHeight,
    @required this.height,
    @required this.buttonWidth,
    @required this.width,
    @required this.loginScreentextPadV,
    @required this.loginScreentextPadH,
  }) : super(key: key);

  final double buttonHeight;
  final double height;
  final double buttonWidth;
  final double width;
  final double loginScreentextPadV;
  final double loginScreentextPadH;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight * height,
      width: buttonWidth * width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (loginScreentextPadV * height / 6.2) * 2,
                vertical: 14 * (loginScreentextPadH * width / 6.2)),
            child: Image.asset('assets/g.png'),
          ),
          SizedBox(width: 10 * (loginScreentextPadH * width / 8)),
          Text(
            'Sign in with Google',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.buttonHeight,
    @required this.height,
    @required this.buttonWidth,
    @required this.width,
    @required this.loginScreentextPadV,
    @required this.loginScreentextPadH,
  }) : super(key: key);
  final double buttonHeight;
  final double height;
  final double buttonWidth;
  final double width;
  final double loginScreentextPadV;
  final double loginScreentextPadH;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight * height,
      width: buttonWidth * width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 5),
            color: Colors.blueAccent[100],
          ),
        ],
        color: Colors.blue,
        borderRadius: BorderRadius.circular(loginPageRadius),
      ),
      child: Center(
        child: Text(
          'Log in',
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key key,
    @required this.fieldPad,
    @required this.height,
  }) : super(key: key);

  final double fieldPad;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Welcome',
          style: TextStyle(
            letterSpacing: 1,
            color: Colors.black,
            fontSize: (fieldPad / 20 * 45) * height,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
