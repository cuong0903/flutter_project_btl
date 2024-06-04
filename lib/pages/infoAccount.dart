import 'package:flutter/material.dart';

class Infoaccount extends StatefulWidget {
  const Infoaccount({super.key});

  @override
  State<Infoaccount> createState() => _InfoaccountState();
}

class _InfoaccountState extends State<Infoaccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Column(
        children: [
          Text("Info Account")
        ],
      ),),
    );
  }
}
