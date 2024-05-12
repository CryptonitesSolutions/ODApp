import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/createod.dart';
import 'package:responsiveapp/screens/pastod.dart';
class OnDuty extends StatefulWidget {
  const OnDuty({Key? key}) : super(key: key);

  @override
  _OnDutyState createState() => _OnDutyState();
}

class _OnDutyState extends State<OnDuty> {
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: Text("OD Details",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: double.infinity,
        child: Container(
          // androidlarge1efb (2:4)
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // autogroupq7tovHf (CPkqaQasnE7zjvnWo2Q7to)
                padding: EdgeInsets.fromLTRB(7 * fem, 111 * fem, 8 * fem, 47 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => pastod()));

                            },
                      child: Container(
                        // btnqvR (5:205)
                        margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 47 * fem),
                        padding: EdgeInsets.fromLTRB(16 * fem, 17 * fem, 16 * fem, 17 * fem),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12 * fem),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0 * fem, 8 * fem),
                              blurRadius: 12 * fem,
                            ),
                          ],
                        ),
                        child: Text(
                          'View your past OD Entries',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter', // Use your desired font family
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.4285714286 * ffem / fem,
                            letterSpacing: 0.1000000015 * fem,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Scene(

                        ))); // Navigate to the Dashboard screen
                      },
                      child: Container(
                        // btnr4q (5:229)
                        padding: EdgeInsets.fromLTRB(16 * fem, 17 * fem, 16 * fem, 17 * fem),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12 * fem),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0 * fem, 8 * fem),
                              blurRadius: 12 * fem,
                            ),
                          ],
                        ),
                        child: Text(
                          'Create a new OD Entry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter', // Use your desired font family
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.4285714286 * ffem / fem,
                            letterSpacing: 0.1000000015 * fem,
                            color: Colors.black,
                            decoration: TextDecoration.none, // Remove underline
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}