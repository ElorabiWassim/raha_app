import 'package:flutter/material.dart';

enum DemandStatus { pending, inProgress, completed, cancelled }

class Demand {
  final String id;
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
    required this.id,
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

  factory Demand.fromJson(Map<String, dynamic> json) {
    final serviceCategories = json['service_categories'];
    String? categoryName;
    if (serviceCategories is Map) {
      categoryName = serviceCategories['name']?.toString();
    }

    return Demand(
      id: (json['demand_id'] ?? json['id'])?.toString() ?? '',
      title: json['title'] ?? '',
      category: categoryName ?? json['category'] ?? '',
      description: json['description'] ?? '',
      postedDate: json['posted_date'] ?? json['postedDate'] ?? '',
      location: json['location'] ?? '',
      budget: json['budget']?.toString() ?? '',
      preferredTime: json['preferred_time'] ?? json['preferredTime'] ?? '',
      status: _parseStatus(json['status']),
      icon: Icons.work, // Default icon, can be customized based on category
      applicantsCount: json['applicants_count'] ?? json['applicantsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'posted_date': postedDate,
      'location': location,
      'budget': budget,
      'preferred_time': preferredTime,
      'status': status.name,
      'applicants_count': applicantsCount,
    };
  }

  static DemandStatus _parseStatus(dynamic status) {
    if (status == null) return DemandStatus.pending;

    final statusStr = status.toString().toLowerCase();
    switch (statusStr) {
      case 'in_progress':
      case 'inprogress':
        return DemandStatus.inProgress;
      case 'completed':
        return DemandStatus.completed;
      case 'cancelled':
        return DemandStatus.cancelled;
      default:
        return DemandStatus.pending;
    }
  }
}
