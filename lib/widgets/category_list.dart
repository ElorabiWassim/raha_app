import 'package:flutter/material.dart';
import './category_widget.dart';
import '../pages/category_screen.dart';

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
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/plumbing.png',
              label: 'Plumbing',
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/electrical.png',
              label: 'Electrical',
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/gardening.png',
              label: 'Gardening',
              destination: CategoryScreen(),
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
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/painting.png',
              label: 'Painting',
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/moving.png',
              label: 'Moving',
              destination: CategoryScreen(),
            ),
            CircleButton(
              icon: 'assets/icons/more.png',
              label: 'More',
              destination: CategoryScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
