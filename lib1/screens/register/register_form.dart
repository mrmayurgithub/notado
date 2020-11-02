// import 'package:flutter/material.dart';
// import 'package:notado/authentication/authentication_bloc.dart';
// import 'package:notado/constants/constants.dart';
// import 'package:notado/login/bloc.dart';
// import 'package:notado/packages/packages.dart';
// import 'package:notado/screens/login/login_screen.dart';
// import 'package:notado/screens/verification/verification.dart';
// import 'package:notado/user_repository/user_Repository.dart';

// class RegisterForm extends StatefulWidget {
//   //UserRepository object needed to pass it to RegisterForm
//   final UserRepository userRepository;

//   const RegisterForm({Key key, @required this.userRepository})
//       : super(key: key);

//   @override
//   _RegisterFormState createState() => _RegisterFormState();
// }

// class _RegisterFormState extends State<RegisterForm> {
//   // ignore: unused_field
//   final TextEditingController _emailController = TextEditingController();
//   // ignore: unused_field
//   final TextEditingController _passwordController = TextEditingController();
//   // ignore: unused_field
//   LoginBloc _loginBloc;
//   bool isPassValid = false;
//   bool isEmailValid = false;
//   bool isPassVisible = false;
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _loginBloc = BlocProvider.of<LoginBloc>(context);
//   }

//   @override
//   void dispose() {
//     //  Closing the _loginBloc instance
//     // _loginBloc.close();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = 1001.0694778740428;
//     final w = 462.03206671109666;
//     final size = MediaQuery.of(context).size;
//     final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final buttonHeight = 58.61497099300238 / h;
//     final buttonWidth = (w - MediaQuery.of(context).size.width / 4.5) /
//         w; //350.02137780739776 / w;
//     final topPad = 120 / h;
//     final loginScreentextPadH = 8 / h;
//     final loginScreentextPadV = 8 / w;
//     final mainColumnPadding = 25 / w;
//     final fieldPad = 23 / h;
//     return BlocListener<LoginBloc, LoginState>(
//       cubit: _loginBloc,
//       listener: (BuildContext context, state) {
//         // if (state is LoginFailure) {
//         //   Scaffold.of(context)
//         //     ..hideCurrentSnackBar()
//         //     ..showSnackBar(
//         //       SnackBar(
//         //         content: Row(
//         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //           children: [Text('Registration Failure'), Icon(Icons.error)],
//         //         ),
//         //         backgroundColor: Colors.red,
//         //       ),
//         //     );
//         // }
//         if (state is NotVerified) {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (BuildContext context) {
//                 return VerificationScreen(
//                     userRepository: widget.userRepository);
//               },
//             ),
//           );
//           //TODO: Add verification code
//           //TODO: Add navigation to another screen that shows email is not verified
//           // Scaffold.of(context)
//           //   ..hideCurrentSnackBar()
//           //   ..showSnackBar(
//           //     SnackBar(
//           //       duration: Duration(hours: 20),
//           //       content: Container(
//           //         height: 100,
//           //         child: Column(
//           //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Text('Verification email sent'),
//           //             Icon(Icons.error),
//           //             FlatButton(
//           //               onPressed: () {
//           //                 BlocProvider.of<LoginBloc>(context)
//           //                     .add(checkVerification());
//           //               },
//           //               child: Text(
//           //                 'Done',
//           //                 style: TextStyle(color: Colors.blue),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //       // backgroundColor: Colors.red,
//           //     ),
//           //   );
//         }
//         // else if (state is VerificationFailure) {
//         //   // Add code
//         //   Scaffold.of(context)
//         //     ..hideCurrentSnackBar()
//         //     ..showSnackBar(
//         //       SnackBar(
//         //         duration: Duration(hours: 2),
//         //         content: Row(
//         //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //           children: [Text('Verification Failure'), Icon(Icons.error)],
//         //         ),
//         //         backgroundColor: Colors.red,
//         //       ),
//         //     );
//         // }
//         //  else if (state is RegistrationSuccess) {
//         //   return BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
//         // }
//         else if (state is RegistrationProgress) {
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//               transitionDuration: Duration(milliseconds: 440),
//               pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
//                 body: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//               transitionsBuilder:
//                   (context, animation, secondaryAnimation, child) {
//                 var curve = Curves.easeInOutQuad;
//                 var tween =
//                     Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
//                 return FadeTransition(
//                   opacity: animation.drive(tween),
//                   child: child,
//                 );
//               },
//             ),
//           );
//           // Scaffold.of(context)
//           //   ..hideCurrentSnackBar()
//           //   ..showSnackBar(
//           //     SnackBar(
//           //       content: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Text('Creating your account...'),
//           //           CircularProgressIndicator(),
//           //         ],
//           //       ),
//           //     ),
//           //   );

//         }
//       },
//       child: BlocBuilder<LoginBloc, LoginState>(
//         cubit: _loginBloc,
//         builder: (context, state) {
//           return Padding(
//             padding: EdgeInsets.all(mainColumnPadding * width),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Enter your details text widget
//                   EnterDetailsWidget(fieldPad: 18 / h, height: height),
//                   SizedBox(height: fieldPad * height),
//                   // TextField for email
//                   TextFormField(
//                     keyboardType: TextInputType.emailAddress,
//                     controller: _emailController,
//                     // autovalidate: true,
//                     autocorrect: false,
//                     validator: (_) {
//                       //validating email
//                       return EmailValidator.validate(_emailController.text)
//                           ? null
//                           : 'Invalid email';
//                       // return _emailController.text.contains("@") ? null : 'Invalid Email';
//                     },
//                     decoration: InputDecoration(
//                       // errorText:
//                       //     _emailController.text.contains('@') ? null : 'Enter a correct email',
//                       prefixIcon: Icon(Icons.mail_outline),
//                       hintText: 'Email',
//                       hintStyle: TextStyle(
//                           color: Colors.black54,
//                           fontWeight: FontWeight.w300,
//                           fontSize: 16),

//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(loginPageRadius),
//                         borderSide: BorderSide(color: Colors.black12),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(loginPageRadius),
//                         borderSide: BorderSide(color: Colors.black12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(loginPageRadius),
//                         borderSide: BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: fieldPad * height),
//                   // passwordTextField
//                   TextFormField(
//                       obscureText: true,
//                       // autovalidate: true,
//                       autocorrect: false,
//                       validator: (_) {
//                         //validating password
//                         return _passwordController.text.length < 6
//                             ? 'Your password should have atleast 6 characters'
//                             : null;
//                       },
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         // errorText:
//                         //     _emailController.text.contains('@') ? null : 'Enter a correct email',
//                         hintText: 'Password',
//                         hintStyle: TextStyle(
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w300,
//                             fontSize: 16),
//                         prefixIcon: Icon(Icons.lock_outline),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             isPassVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               isPassVisible = !isPassVisible;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(loginPageRadius),
//                           borderSide: BorderSide(color: Colors.black12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(loginPageRadius),
//                           borderSide: BorderSide(color: Colors.black12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(loginPageRadius),
//                           borderSide: BorderSide(color: Colors.blue),
//                         ),
//                       )),
//                   SizedBox(height: fieldPad * height),
//                   Padding(
//                     padding: EdgeInsets.symmetric(vertical: fieldPad * height),
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             if (_formKey.currentState.validate()) {
//                               // Adding event SubmitButtonPressed to iniitiate login

//                               BlocProvider.of<LoginBloc>(context).add(
//                                 SubmitButtonPressed(
//                                   email: _emailController.text,
//                                   password: _passwordController.text,
//                                 ),
//                               );
//                             } else {
//                               //TODO: Implement else function
//                             }
//                           },
//                           child: SignUpButton(
//                             buttonHeight: buttonHeight,
//                             height: height,
//                             buttonWidth: buttonWidth,
//                             width: width,
//                             loginScreentextPadV: loginScreentextPadV,
//                             loginScreentextPadH: loginScreentextPadH,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Already have an account ? '),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(context, MaterialPageRoute(
//                               builder: (BuildContext context) {
//                             return LoginScreen(
//                                 userRepository: widget.userRepository);
//                           }));
//                         },
//                         child: Text(
//                           'Signin',
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class SignUpButton extends StatelessWidget {
//   const SignUpButton({
//     Key key,
//     @required this.buttonHeight,
//     @required this.height,
//     @required this.buttonWidth,
//     @required this.width,
//     @required this.loginScreentextPadV,
//     @required this.loginScreentextPadH,
//   }) : super(key: key);
//   final double buttonHeight;
//   final double height;
//   final double buttonWidth;
//   final double width;
//   final double loginScreentextPadV;
//   final double loginScreentextPadH;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 16,
//       width: MediaQuery.of(context).size.width / 1.5,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 5,
//             offset: Offset(0, 5),
//             color: Colors.blueAccent[100],
//           ),
//         ],
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(loginPageRadius),
//       ),
//       child: Center(
//         child: Text(
//           'Sign Up',
//           style: TextStyle(
//             fontSize: 17,
//             color: Colors.white,
//             fontWeight: FontWeight.w300,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class EnterDetailsWidget extends StatelessWidget {
//   const EnterDetailsWidget({
//     Key key,
//     @required this.fieldPad,
//     @required this.height,
//   }) : super(key: key);

//   final double fieldPad;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Enter your details',
//           style: TextStyle(
//             letterSpacing: 1,
//             color: Colors.black,
//             fontSize: (fieldPad / 20 * 45) * height,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
