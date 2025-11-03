import 'package:flutter/material.dart';
import '../pages/add_demand.dart';

class HomeDemand extends StatelessWidget {
  const HomeDemand({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: 416,
      height: 121,
      decoration: BoxDecoration(
        color: const Color(0xFFECFDE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Can't find a service?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Color(0xFF8DC285),
                  ),
                ),
                SizedBox(height: 6),

                Text(
                  "Let us know what you need, and we'll find\na professional for you.",
                  style: TextStyle(
                    color: Color(0xFFBED7B3),
                    fontSize: 14.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDemand()),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF53B538),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
