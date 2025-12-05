import 'package:flutter/material.dart';

enum DemandStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

class Demand {
  final String title;
  final String category;
  final String description;
  final String postedDate;
  final String location;
  final String budget;
  final String preferredTime;
  final DemandStatus status;
  final IconData icon;
  final int applicantsCount;

  Demand({
    required this.title,
    required this.category,
    required this.description,
    required this.postedDate,
    required this.location,
    required this.budget,
    required this.preferredTime,
    required this.status,
    required this.icon,
    this.applicantsCount = 0,
  });
}