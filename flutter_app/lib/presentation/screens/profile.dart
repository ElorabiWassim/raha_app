import 'package:flutter/material.dart';
import '../themes/app_text_style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/models/service_provider_model.dart';
import 'book_service.dart';

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
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.grey,
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
          'Profile',
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
          gradient: AppColors.mainBackgroundGradient,
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
                          '(${provider.reviewCount} reviews)',
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
                              "Message",
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
                              "Call",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
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
                              child: _buildStat(provider.jobsDone, 'Jobs Done'),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                            Expanded(
                              child: _buildStat(
                                provider.experience,
                                'Experience',
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
                                'Response',
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
                            label: 'Background Checked',
                          ),
                          SizedBox(height: 8),
                          _buildBadge(
                            icon: Icons.shield,
                            label: 'Licensed & Insured',
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
                    _buildTab("Services", 'services', servicesKey),
                    _buildTab("Reviews", 'reviews', reviewsKey),
                    _buildTab("Portfolio", 'portfolio', portfolioKey),
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
        color: AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
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
                // Navigate to the details page (replace with your actual page)
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
              'Reviews Summary',
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
                      'Based on $reviewCount reviews',
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
              'Portfolio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Portfolio items will be displayed here.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
