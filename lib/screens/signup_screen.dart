import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsiveapp/reusable_widgets/reusable_widget.dart';
import 'package:responsiveapp/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/signin_screen.dart';
import '/responsive/desktop_body.dart';
import '/responsive/tablet_body.dart';
import '/responsive/mobile_body.dart';
import '/responsive/responsive_layout.dart';
import 'package:responsiveapp/screens/verifyemail.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  String _dropdownValue = "Student";

  List<String> dropDownOptions = [
    "Student",
    "Teacher",

  ];

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Id", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),

                DropdownButton(
                  items: dropDownOptions
                      .map<DropdownMenuItem<String>>((String mascot) {
                    return DropdownMenuItem<String>(
                        child: Text(mascot), value: mascot);
                  }).toList(),
                  value: _dropdownValue,
                  onChanged: dropdownCallback,
                  style: TextStyle(color: Colors.black.withOpacity(0.9)),


                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up")
              ],
            ),
          ))),
    );
  }
  Container firebaseUIButton(BuildContext context, String title) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          signUp(_emailTextController.text, _passwordTextController.text,_dropdownValue);

        },
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
      ),
    );
  }

  Image logoWidget(String imageName) {
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 240,
      height: 240,
      color: Colors.white,
    );
  }

  TextField reusableTextField(String text, IconData icon, bool isPasswordType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
    );
  }








  void signUp(String email, String password, String roll) async {
    // if (email.endsWith('@gmail.com')) {
    //   // Display an alert for users trying to sign up with @gmail.com domain.
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text('Sign Up Error'),
    //         content: Text('Sign up with @gmail.com domain is not allowed.'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop(); // Close the alert dialog
    //             },
    //             child: Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      postDetailsToFirestore(email, roll);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email')
        {

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sign Up Error'),
                content: Text('Enter a valid email'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the alert dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );

        }
      // Display an error alert
        else if (e.code == "weak-password")
          {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sign Up Error'),
                  content: Text('Enter a password with at least 6 characters.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the alert dialog
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
    }
  }

  postDetailsToFirestore(String email, String roll) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    CollectionReference dataref = FirebaseFirestore.instance.collection("userData");
    CollectionReference colref = FirebaseFirestore.instance.collection('teacherchk');
    colref.doc(user!.uid).set({"null":"null"});
    ref.doc(user!.uid).set({'email': _emailTextController.text, 'roll': roll});
    dataref.doc(user!.uid).set({"roll":roll});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
  }

}
