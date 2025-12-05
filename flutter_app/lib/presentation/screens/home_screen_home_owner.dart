import 'package:flutter/material.dart';
import '../themes/app_text_style.dart';
import '../widgets/search_box.dart';
import '../widgets/category_list.dart';
import '../widgets/Home_Demand.dart';
import '../widgets/proffesionalCardWidget.dart';

class HomeScreenHomeOwner extends StatefulWidget {
  const HomeScreenHomeOwner({super.key});

  @override
  State<HomeScreenHomeOwner> createState() => _HomeScreenHomeOwnerState();
}

class _HomeScreenHomeOwnerState extends State<HomeScreenHomeOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.mainBackgroundGradient,
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
                    backgroundImage: AssetImage(
                      'assets/images/MohammedPicture.png',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Salam Wassim",
                      style: TextStyle(
                        color: AppColors.primary,
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
                  "Browse Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              CategoryList(),
              HomeDemand(),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
                child: Text(
                  "Top Rated Near You",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ProfessionalCard(
                name: 'Amine Faiz',
                profession: 'Master Plumber',
                rating: 4.9,
                reviews: 124,
                imagePath: 'assets/images/JohnDoe.png',
              ),
              ProfessionalCard(
                name: 'Maria Haniya',
                profession: 'Expert Carp',
                rating: 5.0,
                reviews: 88,
                imagePath: 'assets/images/Maria.png',
              ),
              ProfessionalCard(
                name: 'Ali Imem',
                profession: 'Gardening & Landscaping',
                rating: 4.8,
                reviews: 150,
                imagePath: 'assets/images/AliImem.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
