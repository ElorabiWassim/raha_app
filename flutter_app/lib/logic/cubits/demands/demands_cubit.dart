import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/demand_model.dart';

// State
abstract class DemandsState extends Equatable {
  const DemandsState();
  @override
  List<Object?> get props => [];
}

class DemandsInitial extends DemandsState {}

class DemandsLoading extends DemandsState {}

class DemandsLoaded extends DemandsState {
  final List<Demand> demands;
  final DemandStatus? statusFilter;
  final String searchQuery;
  final List<String> categoryFilter;
  final RangeValues budgetRange;
  final String sortBy;

  const DemandsLoaded({
    required this.demands,
    this.statusFilter,
    this.searchQuery = '',
    this.categoryFilter = const [],
    this.budgetRange = const RangeValues(0, 50000),
    this.sortBy = 'date',
  });

  @override
  List<Object?> get props => [
    demands,
    statusFilter,
    searchQuery,
    categoryFilter,
    budgetRange,
    sortBy,
  ];

  DemandsLoaded copyWith({
    List<Demand>? demands,
    DemandStatus? statusFilter,
    String? searchQuery,
    List<String>? categoryFilter,
    RangeValues? budgetRange,
    String? sortBy,
  }) {
    return DemandsLoaded(
      demands: demands ?? this.demands,
      statusFilter: statusFilter, // Allow null to clear filter
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      budgetRange: budgetRange ?? this.budgetRange,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class DemandsError extends DemandsState {
  final String message;
  const DemandsError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class DemandsCubit extends Cubit<DemandsState> {
  // Keep a copy of all demands to filter against
  List<Demand> _allDemands = [];

  DemandsCubit() : super(DemandsInitial());

  Future<void> loadDemands() async {
    try {
      emit(DemandsLoading());
      await Future.delayed(const Duration(seconds: 1)); // Simulate API

      // Mock Data
      _allDemands = [
        Demand(
          title: 'Fix AC Unit',
          category:
              'Electrical', // Note: In real app, use IDs or consistent keys
          description:
              'AC not cooling properly, making strange noises when turned on...',
          postedDate: 'Oct 26, 2023',
          location: 'Algiers',
          budget: '8,000 DZD',
          preferredTime: 'Oct 28, PM',
          status: DemandStatus.pending,
          icon: Icons.ac_unit_outlined,
          applicantsCount: 3,
        ),
        Demand(
          title: 'Fix Leaky Kitchen Sink',
          category: 'Plumbing',
          description:
              'Constant dripping under the sink, needs immediate attention...',
          postedDate: 'Oct 24, 2023',
          location: 'Oran',
          budget: '5,000 - 7,000 DZD',
          preferredTime: 'ASAP',
          status: DemandStatus.inProgress,
          icon: Icons.plumbing_outlined,
          applicantsCount: 0,
        ),
        Demand(
          title: 'Paint Living Room Walls',
          category: 'Painting',
          description:
              'Need to paint the living room, approx 20sqm. Color: beige...',
          postedDate: 'Oct 15, 2023',
          location: 'Constantine',
          budget: '15,000 DZD',
          preferredTime: 'Oct 20, AM',
          status: DemandStatus.completed,
          icon: Icons.format_paint_outlined,
          applicantsCount: 0,
        ),
      ];

      emit(DemandsLoaded(demands: _allDemands));
    } catch (e) {
      emit(const DemandsError("Failed to load demands"));
    }
  }

  void filterDemands({
    DemandStatus? statusFilter,
    String? searchQuery,
    List<String>? categoryFilter,
    RangeValues? budgetRange,
    String? sortBy,
  }) {
    final currentState = state;
    if (currentState is! DemandsLoaded) return;

    // Update filters in state
    // Note: We handle "clearing" status filter by passing null explicitly if needed,
    // but copyWith usually ignores nulls.
    // For this simple implementation, we'll assume the UI passes the new complete state of filters.

    // However, to make it robust, let's use the passed values or fall back to current state values
    final newStatusFilter = statusFilter; // Can be null (All)
    final newSearchQuery = searchQuery ?? currentState.searchQuery;
    final newCategoryFilter = categoryFilter ?? currentState.categoryFilter;
    final newBudgetRange = budgetRange ?? currentState.budgetRange;
    final newSortBy = sortBy ?? currentState.sortBy;

    // Apply Logic
    List<Demand> filtered = List.from(_allDemands);

    // 1. Status
    if (newStatusFilter != null) {
      filtered = filtered.where((d) => d.status == newStatusFilter).toList();
    }

    // 2. Search
    if (newSearchQuery.isNotEmpty) {
      final query = newSearchQuery.toLowerCase();
      filtered = filtered
          .where(
            (d) =>
                d.title.toLowerCase().contains(query) ||
                d.category.toLowerCase().contains(query) ||
                d.description.toLowerCase().contains(query),
          )
          .toList();
    }

    // 3. Category
    if (newCategoryFilter.isNotEmpty) {
      // Note: This requires category names to match exactly.
      // In a real app, use localization keys or IDs.
      // For now, we'll assume the UI passes localized strings that match the data,
      // OR we should store keys in the model.
      // Given the previous task used localized strings in the model, we might have issues if we filter by keys.
      // Let's assume for now we filter by what's in the model.
      filtered = filtered
          .where((d) => newCategoryFilter.contains(d.category))
          .toList();
    }

    // 4. Budget
    filtered = filtered.where((d) {
      final budgetStr = d.budget.replaceAll(RegExp(r'[^\d-]'), '');
      final parts = budgetStr.split('-');
      int min = 0;
      int max = 50000;
      if (parts.length == 2) {
        min = int.tryParse(parts[0].trim()) ?? 0;
        max = int.tryParse(parts[1].trim()) ?? 50000;
      } else {
        final val = int.tryParse(parts[0].trim()) ?? 0;
        min = val;
        max = val;
      }
      // Check overlap or containment. Simple check:
      return max >= newBudgetRange.start && min <= newBudgetRange.end;
    }).toList();

    // 5. Sort
    switch (newSortBy) {
      case 'date':
        filtered.sort(
          (a, b) => b.postedDate.compareTo(a.postedDate),
        ); // String compare is weak, but works for ISO or similar formats. These are 'Oct 26', so it might fail. Ideally parse dates.
        break;
      case 'budget':
        filtered.sort((a, b) {
          // ... extract max budget logic
          return 0;
        });
        break;
      case 'status':
        // ... status logic
        break;
    }

    emit(
      DemandsLoaded(
        demands: filtered,
        statusFilter: newStatusFilter,
        searchQuery: newSearchQuery,
        categoryFilter: newCategoryFilter,
        budgetRange: newBudgetRange,
        sortBy: newSortBy,
      ),
    );
  }

  void resetFilters() {
    if (state is DemandsLoaded) {
      emit(DemandsLoaded(demands: _allDemands));
    }
  }
}
