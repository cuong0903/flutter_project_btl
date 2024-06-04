import 'package:flutter/material.dart';

import 'home.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615), // Corrected color code
      body: Container(
        margin: EdgeInsets.only(top: 120.0),
        child: Column(
          children: [
            SizedBox(height: 50.0,),
            Image.asset('images/barber.png'),
            SizedBox(height: 50.0,),
            
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Color(0xFFdf711a), borderRadius: BorderRadius.circular(25)
                ),
                child:  Text("Get a Stylísh Haircut, ", style: TextStyle(
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