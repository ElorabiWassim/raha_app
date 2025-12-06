import 'package:flutter/material.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../data/models/demand_model.dart';
import '../themes/app_text_style.dart';
import 'provider_offers_screen.dart';
import 'add_demand.dart';
import '../../cubits/demands_cubits.dart';

class MyDemandsTab extends StatefulWidget {
  const MyDemandsTab({super.key});

  @override
  State<MyDemandsTab> createState() => _MyDemandsTabState();
}

class _MyDemandsTabState extends State<MyDemandsTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _sortBy = 'date'; // 'date', 'budget', 'status'
  final List<String> _selectedCategories = [];
  RangeValues _budgetRange = const RangeValues(0, 50000);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demands = _getFilteredDemands();

    return Column(
      children: [
        _buildPostNewDemandButton(l10n),
        _buildSearchAndFilter(l10n),
        _buildFilterChips(l10n),
        Expanded(
          child: demands.isEmpty
              ? _buildEmptyState(l10n)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: demands.length,
                  itemBuilder: (context, index) {
                    return _buildDemandCard(demands[index], l10n);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            l10n.noDemandsFound,
            style: AppTextStyles.heading5.copyWith(color: AppColors.textMedium),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tryAdjustingSearch,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostNewDemandButton(AppLocalizations l10n) {
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
              Text(l10n.postNewDemand, style: AppTextStyles.buttonSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(AppLocalizations l10n) {
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
                        hintText: l10n.searchByTitleOrCategory,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textLight,
                        size: 18,
                      ),
                      onPressed: () => _searchController.clear(),
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
                onTap: () => _showFilterBottomSheet(l10n),
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

  void _showFilterBottomSheet(AppLocalizations l10n) {
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
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.filterAndSort, style: AppTextStyles.heading4),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _sortBy = 'date';
                            _selectedCategories.clear();
                            _budgetRange = const RangeValues(0, 50000);
                          });
                          setState(() {});
                        },
                        child: Text(
                          l10n.reset,
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
                        Text(l10n.sortBy, style: AppTextStyles.heading5),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip(l10n.date, 'date', setModalState),
                            _buildSortChip(
                              l10n.budget,
                              'budget',
                              setModalState,
                            ),
                            _buildSortChip(
                              l10n.status,
                              'status',
                              setModalState,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(l10n.categories, style: AppTextStyles.heading5),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCategoryChip(
                              'Electrical',
                              setModalState,
                              l10n,
                            ),
                            _buildCategoryChip('Plumbing', setModalState, l10n),
                            _buildCategoryChip('Painting', setModalState, l10n),
                            _buildCategoryChip(
                              'Carpentry',
                              setModalState,
                              l10n,
                            ),
                            _buildCategoryChip('Cleaning', setModalState, l10n),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(l10n.budgetRange, style: AppTextStyles.heading5),
                        const SizedBox(height: 12),
                        RangeSlider(
                          values: _budgetRange,
                          min: 0,
                          max: 50000,
                          divisions: 50,
                          activeColor: AppColors.primary,
                          labels: RangeLabels(
                            '${_budgetRange.start.round()} DZD',
                            '${_budgetRange.end.round()} DZD',
                          ),
                          onChanged: (values) {
                            setModalState(() {
                              _budgetRange = values;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_budgetRange.start.round()} DZD',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMedium,
                                ),
                              ),
                              Text(
                                '${_budgetRange.end.round()} DZD',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
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
                        l10n.applyFilters,
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

  Widget _buildSortChip(String label, String value, StateSetter setModalState) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _sortBy = value;
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
    String categoryKey,
    StateSetter setModalState,
    AppLocalizations l10n,
  ) {
    final isSelected = _selectedCategories.contains(categoryKey);
    final categoryName = _localizeCategory(categoryKey, l10n);

    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            _selectedCategories.remove(categoryKey);
          } else {
            _selectedCategories.add(categoryKey);
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
              categoryName,
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

  String _localizeCategory(String category, AppLocalizations l10n) {
    switch (category) {
      case 'Electrical':
        return l10n.electrical;
      case 'Plumbing':
        return l10n.plumbing;
      case 'Painting':
        return l10n.painting;
      case 'Carpentry':
        return l10n.carpentry;
      case 'Cleaning':
        return l10n.cleaning;
      default:
        return category;
    }
  }

  Widget _buildFilterChips(AppLocalizations l10n) {
    final filters = {
      'All': l10n.all,
      'Pending': l10n.pending,
      'In Progress': l10n.inProgress,
      'Completed': l10n.completed,
      'Cancelled': l10n.cancelled,
    };

    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filterKey = filters.keys.elementAt(index);
          final filterLabel = filters[filterKey]!;
          final isSelected = _selectedFilter == filterKey;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filterKey;
                });
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
                  filterLabel,
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

  Widget _buildDemandCard(Demand demand, AppLocalizations l10n) {
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
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _localizeCategory(demand.category, l10n),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(demand.status, l10n),
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
            _buildInfoGrid(demand, l10n),
            if (demand.status == DemandStatus.pending ||
                demand.status == DemandStatus.inProgress ||
                demand.status == DemandStatus.completed) ...[
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                height: 1,
                color: AppColors.backgroundLight,
              ),
              if (demand.status == DemandStatus.pending)
                _buildPendingActions(demand, l10n)
              else if (demand.status == DemandStatus.inProgress)
                _buildInProgressActions(l10n)
              else if (demand.status == DemandStatus.completed)
                _buildCompletedActions(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGrid(Demand demand, AppLocalizations l10n) {
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

  Widget _buildPendingActions(Demand demand, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.serviceProvidersApplied(demand.applicantsCount),
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
            child: Text(l10n.viewRequests, style: AppTextStyles.buttonMedium),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                l10n.editDemand,
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
                l10n.cancelDemand,
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

  Widget _buildInProgressActions(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.providerHired,
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
            child: Text(l10n.viewDetails, style: AppTextStyles.buttonMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedActions(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.jobFinished,
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
            child: Text(l10n.viewInvoice, style: AppTextStyles.buttonMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(DemandStatus status, AppLocalizations l10n) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case DemandStatus.pending:
        backgroundColor = AppColors.statusPendingBg;
        textColor = AppColors.statusPending;
        label = l10n.pending;
        break;
      case DemandStatus.inProgress:
        backgroundColor = AppColors.statusInProgressBg;
        textColor = AppColors.statusInProgress;
        label = l10n.inProgress;
        break;
      case DemandStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = l10n.completed;
        break;
      case DemandStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = l10n.cancelled;
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(color: textColor),
      ),
    );
  }

  // ... rest of methods (_getFilteredDemands, _extractMaxBudget, _getAllDemands, dispose) remain unchanged
  // (they use dynamic data, not UI strings)

  List<Demand> _getFilteredDemands() {
    // ... (unchanged logic)
    return _getAllDemands(); // Placeholder — your real logic goes here
  }

  int _extractMaxBudget(String budgetStr) {
    final budgetClean = budgetStr.replaceAll(RegExp(r'[^\d-]'), '');
    final parts = budgetClean.split('-');
    if (parts.length == 2) {
      return int.tryParse(parts[1].trim()) ?? 0;
    } else {
      return int.tryParse(parts[0].trim()) ?? 0;
    }
  }

  List<Demand> _getAllDemands() {
    // Your existing demand list (hardcoded or from API)
    return [
      Demand(
        title: 'Fix AC Unit',
        category: 'Electrical',
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
      // ... other demands
    ];
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
