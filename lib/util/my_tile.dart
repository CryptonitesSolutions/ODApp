import 'package:flutter/material.dart';
import 'package:responsiveapp/screens/to_do.dart';
class MyTile extends StatelessWidget {
  const MyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // Add the action you want to perform when the box is clicked.
          // For example, you can navigate to another screen.
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage1(); // Replace with the screen you want to navigate to
          }));
        },
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: Center(
            child: Text(
              'TO-DO',
              style: TextStyle(
                color: Colors.black, // Change the text color
                fontWeight: FontWeight.bold, // Customize the text style
              ),
            ),
          ),
        ),
      ),
    );
  }
}
