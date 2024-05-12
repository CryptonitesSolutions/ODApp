import 'package:flutter/material.dart';


class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          Text("Developers",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

          PersonCard(
            name: 'Madan Raj M A',
            rollNo: '22ADR059',
            college: 'Kongu Engineering College',
          ),
          SizedBox(height: 20.0),
          PersonCard(
            name: 'Gokul T',
            rollNo: '22ADR029',
            college: 'Kongu Engineering College',
          ),


        ],
      ),
    );
  }
}

class PersonCard extends StatelessWidget {
  final String name;
  final String rollNo;
  final String college;

  const PersonCard({
    required this.name,
    required this.rollNo,
    required this.college,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Roll No: $rollNo'),
            SizedBox(height: 8.0),
            Text('College: $college'),
          ],
        ),
      ),
    );
  }
}
