import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/models/service_provider_model.dart';
import 'book_service.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class Providerprofile extends StatefulWidget {
  final ServiceProvider serviceProvider;

  const Providerprofile({super.key, required this.serviceProvider});

  @override
  State<Providerprofile> createState() => _ProviderprofileState();
}

class _ProviderprofileState extends State<Providerprofile> {
  final servicesKey = GlobalKey();
  final reviewsKey = GlobalKey();
  final portfolioKey = GlobalKey();
  String _selectedTab = 'services';
  final ScrollController _scrollController = ScrollController();

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTab(String label, String value, GlobalKey key) {
    final isActive = _selectedTab == value;

    return InkWell(
      onTap: () {
        setState(() => _selectedTab = value);
        _scrollToSection(key);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF68E36C) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF68E36C) : Colors.grey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = widget.serviceProvider;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          l10n.profile,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F6E0), Color(0xFFFFFFFF), Color(0xFFF9FFF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(provider.imagePath),
                    ),
                    SizedBox(height: 12),
                    Text(
                      provider.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      provider.profession,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      provider.location,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBarIndicator(
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          rating: provider.rating,
                          itemCount: 5,
                          itemSize: 20,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${provider.rating}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${provider.reviewCount} ${l10n.reviews})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.message_outlined,
                              color: Colors.grey[700],
                            ),
                            label: Text(
                              l10n.message,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.call, color: Colors.white),
                            label: Text(
                              l10n.call,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF68E36C),
                              padding: EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStat(provider.jobsDone, l10n.jobsDone),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildStat(
                                provider.experience,
                                l10n.experience,
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildStat(
                                provider.responseTime,
                                l10n.response,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildBadge(
                            icon: Icons.verified_user,
                            label: l10n.backgroundChecked,
                          ),
                          SizedBox(height: 8),
                          _buildBadge(
                            icon: Icons.shield,
                            label: l10n.licensedInsured,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTab(l10n.services, 'services', servicesKey),
                    _buildTab(l10n.reviewsTab, 'reviews', reviewsKey),
                    _buildTab(l10n.portfolio, 'portfolio', portfolioKey),
                  ],
                ),
              ),

              _buildServicesSection(servicesKey, provider.services),
              _buildReviewsSection(
                reviewsKey,
                provider.rating,
                provider.reviewCount,
              ),
              _buildPortfolioSection(portfolioKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildBadge({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF68E36C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFF68E36C), size: 18),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF68E36C),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(GlobalKey key, List<Service> services) {
    return Container(
      key: key,
      padding: EdgeInsets.all(16),
      child: Column(
        children: services.map((service) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BookService(service_name: service.title),
                  ),
                );
              },
              child: _buildServiceCard(
                service.title,
                '${service.pricingModel} ${service.price}',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceCard(String title, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            price,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      ),
    );
  }

  Widget _buildReviewsSection(GlobalKey key, double rating, int reviewCount) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      key: key,
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reviewsSummary,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBarIndicator(
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      rating: rating,
                      itemCount: 5,
                      itemSize: 18,
                      direction: Axis.horizontal,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${l10n.basedOn} $reviewCount ${l10n.reviews}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.90),
                      _buildRatingBar(4, 0.08),
                      _buildRatingBar(3, 0.01),
                      _buildRatingBar(2, 0.01),
                      _buildRatingBar(1, 0.00),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF68E36C)),
              minHeight: 6,
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 35,
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection(GlobalKey key) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      key: key,
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.portfolio,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              l10n.portfolioDescription,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}