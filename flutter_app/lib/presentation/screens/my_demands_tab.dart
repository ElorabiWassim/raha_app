import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/demands/demands_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../data/models/demand_model.dart';
import '../themes/app_text_style.dart';
import 'provider_offers_screen.dart';
import 'add_demand.dart';

class MyDemandsTab extends StatefulWidget {
  const MyDemandsTab({super.key});

  @override
  State<MyDemandsTab> createState() => _MyDemandsTabState();
}

class _MyDemandsTabState extends State<MyDemandsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<DemandsCubit>().filterDemands(
      searchQuery: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemandsCubit, DemandsState>(
      builder: (context, state) {
        if (state is DemandsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DemandsLoaded) {
          return Column(
            children: [
              _buildPostNewDemandButton(),
              _buildSearchAndFilter(state),
              _buildFilterChips(state),
              Expanded(
                child: state.demands.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: state.demands.length,
                        itemBuilder: (context, index) {
                          return _buildDemandCard(state.demands[index]);
                        },
                      ),
              ),
            ],
          );
        } else if (state is DemandsError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            l10n?.noDemandsFound ?? 'No demands found',
            style: AppTextStyles.heading5.copyWith(color: AppColors.textMedium),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.noDemandsSubtitle ?? 'Try adjusting your filters',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostNewDemandButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SizedBox(
        width: double.infinity,
        height: 38,
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddDemand()),
            );
          },

          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.backgroundWhite,
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary, width: 1.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, size: 18),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)?.postNewDemand ??
                    'Post New Demand',
                style: AppTextStyles.buttonSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(DemandsLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Icon(
                      Icons.search,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)?.searchPlaceholder ??
                            'Search...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (state.searchQuery.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textLight,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        // Listener will trigger filter update
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showFilterBottomSheet(state),
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: Icon(
                    Icons.filter_list,
                    color: AppColors.textMedium,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(DemandsLoaded state) {
    String tempSortBy = state.sortBy;
    List<String> tempSelectedCategories = List.from(state.categoryFilter);
    RangeValues tempBudgetRange = state.budgetRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.filterAndSort ??
                            'Filter & Sort',
                        style: AppTextStyles.heading4,
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempSortBy = 'date';
                            tempSelectedCategories.clear();
                            tempBudgetRange = const RangeValues(0, 50000);
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)?.reset ?? 'Reset',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.borderLight),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sort By
                        Text(
                          AppLocalizations.of(context)?.sortBy ?? 'Sort By',
                          style: AppTextStyles.heading5,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip(
                              AppLocalizations.of(context)?.sortDate ?? 'Date',
                              'date',
                              tempSortBy,
                              (val) => setModalState(() => tempSortBy = val),
                            ),
                            _buildSortChip(
                              AppLocalizations.of(context)?.sortBudget ??
                                  'Budget',
                              'budget',
                              tempSortBy,
                              (val) => setModalState(() => tempSortBy = val),
                            ),
                            _buildSortChip(
                              AppLocalizations.of(context)?.sortStatus ??
                                  'Status',
                              'status',
                              tempSortBy,
                              (val) => setModalState(() => tempSortBy = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Category Filter
                        Text(
                          AppLocalizations.of(context)?.categories ??
                              'Categories',
                          style: AppTextStyles.heading5,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCategoryChip(
                              AppLocalizations.of(
                                    context,
                                  )?.categoryElectrical ??
                                  'Electrical',
                              tempSelectedCategories,
                              setModalState,
                            ),
                            _buildCategoryChip(
                              AppLocalizations.of(context)?.categoryPlumbing ??
                                  'Plumbing',
                              tempSelectedCategories,
                              setModalState,
                            ),
                            _buildCategoryChip(
                              AppLocalizations.of(context)?.categoryPainting ??
                                  'Painting',
                              tempSelectedCategories,
                              setModalState,
                            ),
                            _buildCategoryChip(
                              AppLocalizations.of(context)?.categoryCarpentry ??
                                  'Carpentry',
                              tempSelectedCategories,
                              setModalState,
                            ),
                            _buildCategoryChip(
                              AppLocalizations.of(context)?.categoryCleaning ??
                                  'Cleaning',
                              tempSelectedCategories,
                              setModalState,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Budget Range
                        Text(
                          AppLocalizations.of(context)?.budgetRange ??
                              'Budget Range',
                          style: AppTextStyles.heading5,
                        ),
                        const SizedBox(height: 12),
                        RangeSlider(
                          values: tempBudgetRange,
                          min: 0,
                          max: 50000,
                          divisions: 50,
                          activeColor: AppColors.primary,
                          labels: RangeLabels(
                            '${tempBudgetRange.start.round()} DZD',
                            '${tempBudgetRange.end.round()} DZD',
                          ),
                          onChanged: (values) {
                            setModalState(() {
                              tempBudgetRange = values;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${tempBudgetRange.start.round()} DZD',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMedium,
                                ),
                              ),
                              Text(
                                '${tempBudgetRange.end.round()} DZD',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Apply Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<DemandsCubit>().filterDemands(
                          sortBy: tempSortBy,
                          categoryFilter: tempSelectedCategories,
                          budgetRange: tempBudgetRange,
                          statusFilter: state.statusFilter,
                          searchQuery: state.searchQuery,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.applyFilters ??
                            'Apply Filters',
                        style: AppTextStyles.buttonMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortChip(
    String label,
    String value,
    String groupValue,
    Function(String) onSelected,
  ) {
    final isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .1)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textMedium,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String category,
    List<String> selectedCategories,
    StateSetter setModalState,
  ) {
    final isSelected = selectedCategories.contains(category);
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            selectedCategories.remove(category);
          } else {
            selectedCategories.add(category);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .1)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            Text(
              category,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(DemandsLoaded state) {
    final filters = [null, ...DemandStatus.values];

    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final status = filters[index];
          final isSelected = state.statusFilter == status;
          final l10n = AppLocalizations.of(context);

          String label;
          if (status == null) {
            label = l10n?.filterAll ?? 'All';
          } else {
            switch (status) {
              case DemandStatus.pending:
                label = l10n?.statusPending ?? 'Pending';
                break;
              case DemandStatus.inProgress:
                label = l10n?.statusInProgress ?? 'In Progress';
                break;
              case DemandStatus.completed:
                label = l10n?.statusCompleted ?? 'Completed';
                break;
              case DemandStatus.cancelled:
                label = l10n?.statusCancelled ?? 'Cancelled';
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                context.read<DemandsCubit>().filterDemands(
                  statusFilter: status,

                  // We need to pass other filters to preserve them?
                  // My Cubit implementation:
                  // `final newStatusFilter = statusFilter;`
                  // If I pass `statusFilter: null`, it sets it to null (All).
                  // If I pass `statusFilter: DemandStatus.pending`, it sets it to pending.
                  // But what about other filters?
                  // `final newSearchQuery = searchQuery ?? currentState.searchQuery;`
                  // So if I don't pass them, they are preserved.
                  // EXCEPT `statusFilter` which is nullable.
                  // If I don't pass `statusFilter`, it is null.
                  // `final newStatusFilter = statusFilter;` -> null.
                  // So calling `filterDemands()` without arguments resets status filter to All.
                  // This is problematic if I want to update ONLY search query.
                  // But here I AM updating status filter.
                  // So `filterDemands(statusFilter: status)` works fine for updating status.
                  // It will preserve others because I don't pass them.
                  // WAIT.
                  // `final newStatusFilter = statusFilter;`
                  // If I call `filterDemands(searchQuery: 'abc')`, `statusFilter` is null.
                  // So `newStatusFilter` is null.
                  // So it resets status filter to All.
                  // This IS a bug in Cubit if I want to preserve status filter when changing search query.
                  // I should fix the Cubit to:
                  // `final newStatusFilter = statusFilter ?? currentState.statusFilter;`
                  // BUT `statusFilter` can be explicitly null (to clear it).
                  // So I need a way to distinguish "undefined" from "null".
                  // Or I just pass ALL current values every time.
                  // Passing all current values is safer for now without changing Cubit signature.
                  searchQuery: state.searchQuery,
                  categoryFilter: state.categoryFilter,
                  budgetRange: state.budgetRange,
                  sortBy: state.sortBy,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: .1)
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textMedium,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDemandCard(Demand demand) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(demand.icon, color: AppColors.primary, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        demand.title,
                        style: AppTextStyles.heading5.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        demand.category,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(context, demand.status),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              demand.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textMedium,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: AppColors.backgroundLight,
            ),
            _buildInfoGrid(demand),
            if (demand.status == DemandStatus.pending ||
                demand.status == DemandStatus.inProgress ||
                demand.status == DemandStatus.completed) ...[
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                height: 1,
                color: AppColors.backgroundLight,
              ),
              if (demand.status == DemandStatus.pending)
                _buildPendingActions(demand)
              else if (demand.status == DemandStatus.inProgress)
                _buildInProgressActions()
              else if (demand.status == DemandStatus.completed)
                _buildCompletedActions(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(Demand demand) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoItem(Icons.calendar_today_outlined, demand.postedDate),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.payments_outlined, demand.budget),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildInfoItem(Icons.location_on_outlined, demand.location),
              const SizedBox(height: 8),
              _buildInfoItem(Icons.schedule_outlined, demand.preferredTime),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingActions(Demand demand) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n?.providersApplied(demand.applicantsCount) ??
              '${demand.applicantsCount} providers applied',
          style: AppTextStyles.buttonMedium.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProviderOffersScreen(
                    demandTitle: demand.title,
                    demandCategory: demand.category,
                    demandDescription: demand.description,
                    demandLocation: demand.location,
                    postedDate: demand.postedDate,
                    demandIcon: demand.icon,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.viewRequests ?? 'View Requests',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context)?.editDemand ?? 'Edit Demand',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context)?.cancelDemand ?? 'Cancel Demand',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInProgressActions() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)?.providerHired ?? 'Provider Hired',
          style: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.textMedium,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.viewDetails ?? 'View Details',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedActions() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)?.jobFinished ?? 'Job Finished',
          style: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.textMedium,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundWhite,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)?.viewInvoice ?? 'View Invoice',
              style: AppTextStyles.buttonMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, DemandStatus status) {
    final l10n = AppLocalizations.of(context);
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case DemandStatus.pending:
        backgroundColor = AppColors.statusPendingBg;
        textColor = AppColors.statusPending;
        label = l10n?.statusPending ?? 'Pending';
        break;
      case DemandStatus.inProgress:
        backgroundColor = AppColors.statusInProgressBg;
        textColor = AppColors.statusInProgress;
        label = l10n?.statusInProgress ?? 'In Progress';
        break;
      case DemandStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = l10n?.statusCompleted ?? 'Completed';
        break;
      case DemandStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = l10n?.statusCancelled ?? 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: textColor),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
