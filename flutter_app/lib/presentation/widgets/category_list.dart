import 'package:flutter/material.dart';
import 'category_widget.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../screens/wilaya_screen.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleButton(
              icon: 'assets/icons/cleaning.png',
              label: l10n.cleaning,
              destination: WilayaScreen(category: "Cleaning"),
            ),
            CircleButton(
              icon: 'assets/icons/plumbing.png',
              label: l10n.plumbing,
              destination: WilayaScreen(category: "Plumbing"),
            ),
            CircleButton(
              icon: 'assets/icons/electrical.png',
              label: l10n.electrical,
              destination: WilayaScreen(category: "Electrical"),
            ),
            Flexible(
              child: CircleButton(
                icon: 'assets/icons/gardening.png',
                label: l10n.gardening,
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
              label: l10n.handyman,
              destination: WilayaScreen(category: "Handyman"),
            ),
            CircleButton(
              icon: 'assets/icons/painting.png',
              label: l10n.painting,
              destination: WilayaScreen(category: "Painting"),
            ),
            CircleButton(
              icon: 'assets/icons/moving.png',
              label: l10n.moving,
              destination: WilayaScreen(category: "Moving"),
            ),
            Flexible(
              child: CircleButton(
                icon: 'assets/icons/more.png',
                label: l10n.more,
                destination: WilayaScreen(category: "More"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
