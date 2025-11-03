import 'package:flutter/material.dart';
import './category_widget.dart';
import '../pages/wilaya_screen.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleButton(
              icon: 'assets/icons/cleaning.png',
              label: 'Cleaning',
              destination: WilayaScreen(category: "Cleaning"),
            ),
            CircleButton(
              icon: 'assets/icons/plumbing.png',
              label: 'Plumbing',
              destination: WilayaScreen(category: "Plumbing"),
            ),
            CircleButton(
              icon: 'assets/icons/electrical.png',
              label: 'Electrical',
              destination: WilayaScreen(category: "Electrical"),
            ),
            Flexible(
              child: CircleButton(
                icon: 'assets/icons/gardening.png',
                label: 'Gardening',
                destination: WilayaScreen(category: "Gardening"),
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleButton(
              icon: 'assets/icons/handyman.png',
              label: 'Handyman',
              destination: WilayaScreen(category: "Handyman"),
            ),
            CircleButton(
              icon: 'assets/icons/painting.png',
              label: 'Painting',
              destination: WilayaScreen(category: "Painting"),
            ),
            CircleButton(
              icon: 'assets/icons/moving.png',
              label: 'Moving',
              destination: WilayaScreen(category: "Moving"),
            ),
            Flexible(
              child: CircleButton(
                icon: 'assets/icons/more.png',
                label: 'More',
                destination: WilayaScreen(category: "More"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
