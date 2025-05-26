import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile/app/routes/app_pages.dart';

import '../controllers/forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'SignEase',
        // style: GoogleFonts.lobster(
        //     textStyle: const TextStyle(fontSize: 20),
        //     color: Colors.orange // Ukuran font
        //     ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/forgot.png',
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Forgot Password',
            // style: GoogleFonts.lobster(
            //     textStyle: const TextStyle(fontSize: 30), color: Colors.orange),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                labelText: 'username', border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => Routes.FORGOT);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              child: Text(
                'Masuk',
                style: TextStyle(color: Colors.white),
              )),
        ]),
      ),
    );
  }
}
