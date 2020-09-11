// import 'package:flutter/material.dart';
// import 'package:notado/screens/home/home_screen.dart';
// import 'package:notado/services/database.dart';
// import 'package:notado/user_repository/user_Repository.dart';

// class HomeSplash extends StatefulWidget {
//   final UserRepository userRepository;

//   const HomeSplash({Key key, this.userRepository}) : super(key: key);

//   @override
//   _HomeSplashState createState() => _HomeSplashState();
// }

// class _HomeSplashState extends State<HomeSplash> {
//   String uid;
//   String photoUrl;
//   String displayName = "";
//   String userEmail;

//   _getDisplayName() async {
//     displayName = await widget.userRepository.getDisplayName();
//   }

//   _getPhotoUrl() async {
//     photoUrl = await widget.userRepository.getPhotoUrl();
//   }

//   _getUserEmail() async {
//     userEmail = await widget.userRepository.getUserEmail();
//   }

//   _getUid() async {
//     uid = await widget.userRepository.getUID();
//   }

//   @override
//   void initState() {
//     _getUid();
//     _getDisplayName();
//     _getPhotoUrl();
//     _getUserEmail();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: DatabaseService(uid: uid).notesZefyrFromNotesOrderByTitle,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError)
//             return Center(
//               child: Text('Some error occured while loading the data'),
//             );
//           else if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.green,
//               ),
//             );
//           return HomeScreen(
//             userRepository: widget.userRepository,
//             uid: uid,
//             userEmail: userEmail,
//             photoUrl: photoUrl,
//             displayName: displayName,
//             snapshot: snapshot,
//           );
//         },
//       ),
//     );
//   }
// }
