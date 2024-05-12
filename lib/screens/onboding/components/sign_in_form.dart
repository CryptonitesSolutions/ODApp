import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsiveapp/screens/reset_password.dart';
import 'package:responsiveapp/screens/signup_screen.dart';
import 'package:responsiveapp/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '/responsive/mobile_body.dart';
import '/responsive/responsive_layout.dart';
import 'package:responsiveapp/screens/to_do.dart';
import 'package:responsiveapp/screens/ondutymob.dart';
import 'package:responsiveapp/screens/teacherdash.dart';
import 'package:responsiveapp/screens/verifyemail.dart';
class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context,email,password) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      bool isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified == false){

        throw FirebaseAuthException(code: 'email-not-verified');


      }

      Future.delayed(Duration(seconds: 1), () {
        if (_formKey.currentState!.validate() && isEmailVerified) {
          // show success
          check.fire();
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
            confetti.fire();
          });
          Future.delayed(Duration(seconds: 3), ()
          {
            route();
          });
        } else {
          error.fire();
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              isShowLoading = false;
            });
          });
        }
      });

    }
    on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-not-verified') {
        // Redirect user to VerifyEmailPage if email is not verified
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmailPage()),
        );
      }
      else{
        // Redirect user to VerifyEmailPage if email is not verified
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    }


  }  void _navigateWithTransition(Widget destination) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => destination,
        transitionsBuilder: (context, animation1, animation2, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation1.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('roll') == "Teacher") {
          print("teacherlogin");
          _navigateWithTransition(teacherdash());
        } else {
          _navigateWithTransition(MobileScaffold());
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: _emailTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onSaved: (email) {},
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    )),
                  ),
                ),
                const Text(
                  "Password",
                  style: TextStyle(color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    controller: _passwordTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onSaved: (password) {},
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset("assets/icons/password.svg"),
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                      onPressed: () {
                        signIn(context,_emailTextController.text,_passwordTextController.text);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF77D8E),
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Color(0xFFFE0037),
                      ),
                      label: const Text("Sign In")),
                )
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }

}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}



