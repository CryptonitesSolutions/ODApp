// import 'package:flutter/material.dart';
// import 'package:easy_upi_payment/easy_upi_payment.dart';
// class donateus extends StatefulWidget {
//   const donateus({Key? key}) : super(key: key);
//   @override
//   State<donateus> createState() => _donateusState();
// }
//
// class _donateusState extends State<donateus> {
//   TextStyle header = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );
//   TextEditingController _amountcontroller = TextEditingController();
//
//   void initializepayment(String amount) async {
//     double amt = double.parse(amount);
//     final res = await EasyUpiPaymentPlatform.instance.startPayment(
//       EasyUpiPaymentModel(
//         payeeVpa: 'gaurav.jajoo@upi',
//         payeeName: 'Madan',
//         amount: amt,
//         description: 'Donation',
//       ),
//     );
//     // TODO: add your success logic here
//     print(res);
//   }
//
//
//
//
//
//
//   @override
//   void initState() {
//
//
//     super.initState();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Support Us"),
//       ),
//       body: Container(
//         margin: EdgeInsets.only(left: 25, right: 25),
//         alignment: Alignment.center,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/donate.png',
//                 width: 150,
//                 height: 150,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Support Us",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Support us with small donations to keep our app and projects going. Your contribution matters in sustaining our work.",
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 1, color: Colors.grey),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         SizedBox(
//                           width: 40,
//                           child: Icon(Icons.currency_rupee),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: TextField(
//                             controller: _amountcontroller,
//                             keyboardType: TextInputType.phone,
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: "Enter amount",
//                             ),
//                           ),
//
//                         ),
//
//                       ],
//                     ),
//                   ],
//
//                 ),
//
//
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.green.shade600,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () {
//                     initializepayment(_amountcontroller.text);
//                   },
//                   child: Text(
//                     "Pay",
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
