import 'package:flutter/material.dart';
import '../widgets/search_box.dart';
import '../widgets/category_list.dart';
import '../widgets/Home_Demand.dart';
import '../widgets/proffesionalCardWidget.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import './topN_rated.dart';

class HomeScreenHomeOwner extends StatefulWidget {
  const HomeScreenHomeOwner({super.key});

  @override
  State<HomeScreenHomeOwner> createState() => _HomeScreenHomeOwnerState();
}

class _HomeScreenHomeOwnerState extends State<HomeScreenHomeOwner> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(20)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 20)),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/alexo.png'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      l10n.greetingWassim,
                      style: TextStyle(
                        color: Color(0xFF53B538),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              SearchBox(),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 30),
                child: Text(
                  l10n.browseCategories,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              CategoryList(),
              HomeDemand(),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  l10n.topRatedNearYou,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              //add top rated nearby
              TopNRated(
                //to choose from all categories
                location: "Blida",
                topN: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
