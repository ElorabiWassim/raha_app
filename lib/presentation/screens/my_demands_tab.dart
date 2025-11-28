import 'package:flutter/material.dart';
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
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter options
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
    final demands = _getFilteredDemands();

    return Column(
      children: [
        _buildPostNewDemandButton(),
        _buildSearchAndFilter(),
        _buildFilterChips(),
        Expanded(
          child: demands.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: demands.length,
                  itemBuilder: (context, index) {
                    return _buildDemandCard(demands[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'No demands found',
            style: AppTextStyles.heading5.copyWith(color: AppColors.textMedium),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
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
              Text('Post New Demand', style: AppTextStyles.buttonSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
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
                        hintText: 'Search by title or category...',
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
                      onPressed: () {
                        _searchController.clear();
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
                onTap: () => _showFilterBottomSheet(),
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

  void _showFilterBottomSheet() {
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
                      Text('Filter & Sort', style: AppTextStyles.heading4),
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
                          'Reset',
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
                        Text('Sort By', style: AppTextStyles.heading5),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildSortChip('Date', 'date', setModalState),
                            _buildSortChip('Budget', 'budget', setModalState),
                            _buildSortChip('Status', 'status', setModalState),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Category Filter
                        Text('Categories', style: AppTextStyles.heading5),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCategoryChip('Electrical', setModalState),
                            _buildCategoryChip('Plumbing', setModalState),
                            _buildCategoryChip('Painting', setModalState),
                            _buildCategoryChip('Carpentry', setModalState),
                            _buildCategoryChip('Cleaning', setModalState),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Budget Range
                        Text('Budget Range', style: AppTextStyles.heading5),
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
                // Apply Button
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

  Widget _buildCategoryChip(String category, StateSetter setModalState) {
    final isSelected = _selectedCategories.contains(category);
    return GestureDetector(
      onTap: () {
        setModalState(() {
          if (isSelected) {
            _selectedCategories.remove(category);
          } else {
            _selectedCategories.add(category);
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

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'In Progress', 'Completed', 'Cancelled'];

    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
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
                  filter,
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
                _buildStatusBadge(demand.status),
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
    return Column(
      children: [
        Text(
          '${demand.applicantsCount} Service Providers Applied',
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
            child: Text('View Requests', style: AppTextStyles.buttonMedium),
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
                'Edit Demand',
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
                'Cancel Demand',
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
          'Provider hired',
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
            child: Text('View Details', style: AppTextStyles.buttonMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedActions() {
    return Column(
      children: [
        Text(
          'Job finished',
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
            child: Text('View Invoice', style: AppTextStyles.buttonMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(DemandStatus status) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case DemandStatus.pending:
        backgroundColor = AppColors.statusPendingBg;
        textColor = AppColors.statusPending;
        label = 'Pending';
        break;
      case DemandStatus.inProgress:
        backgroundColor = AppColors.statusInProgressBg;
        textColor = AppColors.statusInProgress;
        label = 'In Progress';
        break;
      case DemandStatus.completed:
        backgroundColor = AppColors.statusCompletedBg;
        textColor = AppColors.statusCompleted;
        label = 'Completed';
        break;
      case DemandStatus.cancelled:
        backgroundColor = AppColors.statusCancelledBg;
        textColor = AppColors.statusCancelled;
        label = 'Cancelled';
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

  List<Demand> _getFilteredDemands() {
    List<Demand> allDemands = _getAllDemands();

    // Apply status filter
    if (_selectedFilter != 'All') {
      allDemands = allDemands.where((demand) {
        switch (_selectedFilter) {
          case 'Pending':
            return demand.status == DemandStatus.pending;
          case 'In Progress':
            return demand.status == DemandStatus.inProgress;
          case 'Completed':
            return demand.status == DemandStatus.completed;
          case 'Cancelled':
            return demand.status == DemandStatus.cancelled;
          default:
            return true;
        }
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      allDemands = allDemands.where((demand) {
        return demand.title.toLowerCase().contains(_searchQuery) ||
            demand.category.toLowerCase().contains(_searchQuery) ||
            demand.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategories.isNotEmpty) {
      allDemands = allDemands.where((demand) {
        return _selectedCategories.contains(demand.category);
      }).toList();
    }

    // Apply budget filter
    allDemands = allDemands.where((demand) {
      // Parse budget string (e.g., "8,000 DZD" or "5,000 - 7,000 DZD")
      final budgetStr = demand.budget.replaceAll(RegExp(r'[^\d-]'), '');
      final parts = budgetStr.split('-');

      if (parts.length == 2) {
        // Range budget
        final minBudget = int.tryParse(parts[0].trim()) ?? 0;
        final maxBudget = int.tryParse(parts[1].trim()) ?? 50000;
        return maxBudget >= _budgetRange.start && minBudget <= _budgetRange.end;
      } else {
        // Single budget value
        final budget = int.tryParse(parts[0].trim()) ?? 0;
        return budget >= _budgetRange.start && budget <= _budgetRange.end;
      }
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'date':
        // Sort by date (newest first)
        allDemands.sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
      case 'budget':
        // Sort by budget (highest first)
        allDemands.sort((a, b) {
          final budgetA = _extractMaxBudget(a.budget);
          final budgetB = _extractMaxBudget(b.budget);
          return budgetB.compareTo(budgetA);
        });
        break;
      case 'status':
        // Sort by status priority: Pending > In Progress > Completed > Cancelled
        final statusPriority = {
          DemandStatus.pending: 0,
          DemandStatus.inProgress: 1,
          DemandStatus.completed: 2,
          DemandStatus.cancelled: 3,
        };
        allDemands.sort((a, b) {
          return (statusPriority[a.status] ?? 4).compareTo(
            statusPriority[b.status] ?? 4,
          );
        });
        break;
    }

    return allDemands;
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
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
