import 'package:flutter/material.dart';

class HomeScreenHomeOwner extends StatefulWidget {
  const HomeScreenHomeOwner({super.key});

  @override
  State<HomeScreenHomeOwner> createState() => _HomeScreenHomeOwnerState();
}

class _HomeScreenHomeOwnerState extends State<HomeScreenHomeOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsetsGeometry.all(20)),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  'assets/images/MohammedPicture.png',
                ),
              ),
              Text("Salam Mohamed"),
            ],
          ),
        ],
      ),
    );
  }
}
