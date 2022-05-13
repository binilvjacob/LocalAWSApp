// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_flutter/amplify.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_home/amplifyconfiguration.dart';
// import 'package:smart_home/main.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:smart_home/models/email_validator.dart';
//
// class Passwordreset extends StatefulWidget {
//   @override
//   _PasswordresetState createState() => _PasswordresetState();
// }
//
// class _PasswordresetState extends State<Passwordreset> {
//   var isPasswordReset;
//   final userController = TextEditingController();
//   final emailController = TextEditingController();
//   final mobController = TextEditingController();
//   final passwordController = TextEditingController();
//   // final SecureStorage secureStorage = SecureStorage();
//
//   bool _amplifyConfigured = false;
//
//   Future<void> _configureAmplify() async {
//     try {
//       AmplifyAuthCognito auth = AmplifyAuthCognito();
//       await Amplify.addPlugin(auth);
//       await Amplify.configure(amplifyconfig);
//       setState(() => _amplifyConfigured = true);
//     } catch (e) {
//       setState(() => _amplifyConfigured = false);
//     }
//     setState(() => _amplifyConfigured = true);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _configureAmplify();
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Center(child: Text("Ligero Home Automation")),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(top: 60.0),
//                 child: Center(
//                   child: Container(
//                       width: 200,
//                       height: 150,
//                       child: Image.asset('assets/images/ligero.jpg')),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: TextFormField(
//                   controller: userController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.person),
//                     border: OutlineInputBorder(),
//                     labelText: 'username',
//                     hintText: 'Enter username',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 height: 50,
//                 width: 175,
//                 decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: FlatButton(
//                   onPressed: () async {
//                     try {
//                       ResetPasswordResult res =
//                           await Amplify.Auth.resetPassword(
//                         username: userController.text,
//                       );
//                       setState(() {
//                         isPasswordReset = res.isPasswordReset;
//                         print("isPasswordReset:$isPasswordReset");
//                         if (isPasswordReset) {
//                           Text('Reset code sent to registered email address');
//                         }
//                       });
//                     } on AmplifyException catch (e) {
//                       print(e);
//                     }
//                   },
//                   child: Text(
//                     'Get Reset Code',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//               //Text('Reset code sent to registered email address'),
//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15.0, right: 15.0, top: 15, bottom: 0),
//                 child: TextFormField(
//                   controller: emailController,
//                   obscureText: false,
//                   decoration: InputDecoration(
//                       icon: Icon(Icons.mail_outline),
//                       border: OutlineInputBorder(),
//                       labelText: 'E-mail',
//                       hintText: 'Enter valid email'),
//                   validator: (value) =>
//                       !validateEmail(value) ? "Email is Invalid" : null,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15.0, right: 15.0, top: 15, bottom: 0),
//                 child: TextFormField(
//                   controller: mobController,
//                   obscureText: false,
//                   decoration: InputDecoration(
//                       icon: Icon(Icons.phone),
//                       border: OutlineInputBorder(),
//                       labelText: 'Mobile Number',
//                       hintText: 'Number with country code(+91.....'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value.length != 13) {
//                       return 'Please enter valid mobile number';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15.0, right: 15.0, top: 15, bottom: 0),
//                 child: TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                       icon: Icon(Icons.security),
//                       border: OutlineInputBorder(),
//                       labelText: 'Password',
//                       hintText: 'Minimum 8 characters'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty || value.length <= 7) {
//                       return 'Password too weak';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//               ),
//               Container(
//                 height: 40,
//                 width: 125,
//                 decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: FlatButton(
//                   onPressed: () async {
//                     if (_formKey.currentState.validate()) {
//                       var userName = userController.text;
//                       var userPass = passwordController.text;
//                       var userMob = mobController.text;
//                       var userEmail = emailController.text;
//                       Map<String, String> userAttributes = {
//                         "email": userEmail,
//                         "phone_number": userMob
//                       };
//
//                       try {
//                         final signUpResult = await Amplify.Auth.signUp(
//                           username: userName,
//                           password: userPass,
//                           options: CognitoSignUpOptions(
//                               userAttributes: userAttributes),
//                         );
//
//                         if (signUpResult.isSignUpComplete) {
//                           Fluttertoast.showToast(
//                             msg: 'Account Created Successfully!',
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.CENTER,
//                           );
//                           try {
//                             Amplify.Auth.signOut();
//                           } on AuthException catch (e) {}
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => LoginDemo()));
//                         }
//                       } on AuthException catch (e) {}
//                     }
//                   },
//                   child: Text(
//                     'Sign Up',
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
