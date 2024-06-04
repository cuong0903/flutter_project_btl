import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';

class Infoaccount extends StatefulWidget {
  final String userId;

  const Infoaccount({Key? key, required this.userId}) : super(key: key);

  @override
  State<Infoaccount> createState() => _InfoaccountState();
}

class _InfoaccountState extends State<Infoaccount> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = DatabaseMethods().getUsers(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Info Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    "images/discount.png",
                    fit: BoxFit.cover,
                    width: 160,
                    height: 160,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: userFuture,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: Text('No user data available'));
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

                  return Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: userData['Name'] ?? 'No username',
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          initialValue: userData['Gmail'] ?? 'No email',
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          initialValue: userData['Number phone'] ?? 'No phone number',
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon: Icon(Icons.phone_callback_outlined),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}