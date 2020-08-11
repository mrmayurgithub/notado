import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/authentication/authentication_bloc.dart';
import 'package:notado/login/bloc.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/screens/register/register_screen.dart';
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
    final fieldPad = 20 / h;
    return BlocListener(
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
        } else if (state is LoginSuccess) {
          return BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        } else if (state is LoginInProgress) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        cubit: _loginBloc,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(mainColumnPadding * width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Welcome Text widget
                WelcomeText(fieldPad: fieldPad, height: height),
                SizedBox(height: fieldPad * height),
                // TextField for email
                emailTextField(),
                SizedBox(height: fieldPad * height),
                //TextField for password
                passwordTextField(),
                SizedBox(height: fieldPad * height),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      //TODO: Implement forgot password here
                      //TODO: add Forgotpassword state
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
                        //TODO: Implement Bloc for logging in
                        onTap: () {},
                        child: LoginButton(),
                      ),
                      SizedBox(height: fieldPad * height),
                      GestureDetector(
                        onTap: () => {
                          //TODO: Implement googleLogin here
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
          );
        },
      ),
    );
  }

  TextFormField passwordTextField() {
    return TextFormField(
      obscureText: true,
      obscuringCharacter: '#',
      autovalidate: true,
      autocorrect: false,
      validator: (_) {
        //validating password
        return _passwordController.text.length < 6
            ? 'Your password should have atleast 6 characters'
            : null;
      },
      controller: _passwordController,
      decoration: inputDecoration(),
    );
  }

  TextFormField emailTextField() {
    return TextFormField(
      controller: _emailController,
      autovalidate: true,
      autocorrect: false,
      validator: (_) {
        //validating email
        return _emailController.text.contains("@") ? 'Invalid Email' : null;
      },
      decoration: inputDecoration(),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      prefixIcon: Icon(Icons.mail_outline),
      hintText: 'Enter your Email',
      hintStyle: hintStyle(),
      enabledBorder: OutlineInputBorder(
        //TODO: Make aa loginPageRadius const in constants.dart file
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        //TODO: Make aa loginPageRadius const in constants.dart file
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  TextStyle hintStyle() {
    return TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w300,
    );
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
              return RegisterScreen(
                userRepository: widget.userRepository,
              );
            },
          ),
        );
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 16,
      width: MediaQuery.of(context).size.width / 1.5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 5),
            color: Colors.blueAccent[100],
          ),
        ],
        color: Colors.blue,
        //TODO: change 7 to loginPageRadius that is in constants
        borderRadius: BorderRadius.circular(7),
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
