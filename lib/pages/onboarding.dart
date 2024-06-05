import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB48A6E), // Corrected color code
      body: Container(
        margin: EdgeInsets.only(top: 120.0),
        child: Column(
          children: [
            SizedBox(height: 50.0,),
            Image.asset('images/barber_preview_rev.png'),
            SizedBox(height: 50.0,),
            
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Login()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Color(0xFFdf711a), borderRadius: BorderRadius.circular(25)
                ),
                child:  Text("Nhận một kiểu tóc sành điệu, ", style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
// TODO Implement this library.