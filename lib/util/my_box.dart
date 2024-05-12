import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/addstud.dart';
// class MyBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.grey[400],
//         ),
//       ),
//     );
//   }
// }

class MyBox extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Center(
        child: InkWell(
          splashColor: Colors.transparent,
        onTap: () {

            Navigator.push(context,MaterialPageRoute(builder: (context) => addstud()));

        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink.image(
            image: AssetImage("assets/adduser.png"),
              height: 100,
            width: 100,
            fit: BoxFit.scaleDown,
                  ),
            SizedBox(height: 6,),
            Text("Add Students",
              style: TextStyle(fontSize: 22,color: Colors.blue,fontWeight: FontWeight.bold),

            ),
            SizedBox(height: 6),
          ],
        ),
    ),

    ),
    );
  }
}
