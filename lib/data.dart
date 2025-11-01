import 'package:flutter/material.dart';

// ============= MODÈLES =============
class ServiceProvider {
  String name;
  String profession;
  String location;
  double rating;
  int reviewCount;
  String jobsDone;
  String experience;
  String responseTime;
  int pendingRequests;
  int confirmedJobs;
  int totalEarnings;
  List<Service> services;
  String? profileImage;

  ServiceProvider({
    required this.name,
    required this.profession,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.jobsDone,
    required this.experience,
    required this.responseTime,
    required this.pendingRequests,
    required this.confirmedJobs,
    required this.totalEarnings,
    required this.services,
    this.profileImage,
  });
}

class Service {
  String title;
  String price;
  bool isActive;
  String category;
  String description;
  String pricingModel;

  Service({
    required this.title,
    required this.price,
    required this.isActive,
    this.category = 'Plumbing',
    this.description = '',
    this.pricingModel = 'Fixed Price',
  });
}

// ============= PAGE DE TEST =============
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile Test',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: EditProviderProfilePage(provider: _getSampleProvider()),
    );
  }

  // Données de test
  static ServiceProvider _getSampleProvider() {
    return ServiceProvider(
      name: "Amjad Axlo",
      profession: "Master Plumber",
      location: "Algiers, Draria",
      rating: 4.9,
      reviewCount: 125,
      jobsDone: "150+",
      experience: "10 yrs",
      responseTime: "< 1hr",
      pendingRequests: 5,
      confirmedJobs: 3,
      totalEarnings: 45000,
      services: [
        Service(
          title: 'Leak Detection & Repair',
          price: 'Starts at 1300 Da',
          isActive: true,
          category: 'Plumbing',
          description: 'Professional leak detection and repair services',
        ),
        Service(
          title: 'Drain Cleaning',
          price: '2500 da per hour',
          isActive: true,
          category: 'Plumbing',
          description: 'Complete drain cleaning and maintenance',
        ),
        Service(
          title: 'Water Heater Installation',
          price: 'Starts at 5000 da',
          isActive: false,
          category: 'Installation',
          description: 'Professional water heater installation',
        ),
      ],
      profileImage: null, // ou 'assets/images/alexo.png' si tu as l'image
    );
  }
}

// ============= PAGE ÉDITION =============
class EditProviderProfilePage extends StatefulWidget {
  final ServiceProvider provider;

  const EditProviderProfilePage({super.key, required this.provider});

  @override
  State<EditProviderProfilePage> createState() => _EditProviderProfilePageState();
}

class _EditProviderProfilePageState extends State<EditProviderProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _locationController;
  late TextEditingController _experienceController;
  late TextEditingController _responseTimeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider.name);
    _professionController = TextEditingController(text: widget.provider.profession);
    _locationController = TextEditingController(text: widget.provider.location);
    _experienceController = TextEditingController(text: widget.provider.experience);
    _responseTimeController = TextEditingController(text: widget.provider.responseTime);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _responseTimeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.provider.name = _nameController.text;
    widget.provider.profession = _professionController.text;
    widget.provider.location = _locationController.text;
    widget.provider.experience = _experienceController.text;
    widget.provider.responseTime = _responseTimeController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Color(0xFF68E36C),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigator.pop(context); // Décommenter si tu veux retourner en arrière
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF68E36C),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Photo Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 60, ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF68E36C),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Photo picker would open here')),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Change Profile Photo',
                    style: TextStyle(
                      color: Color(0xFF68E36C),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Informations de base
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Profession',
                    controller: _professionController,
                    icon: Icons.work_outline,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Location',
                    controller: _locationController,
                    icon: Icons.location_on_outlined,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Experience',
                    controller: _experienceController,
                    icon: Icons.stars_outlined,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: 'Response Time',
                    controller: _responseTimeController,
                    icon: Icons.schedule_outlined,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Services Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            widget.provider.services.add(
                              Service(
                                title: 'New Service',
                                price: '0 Da',
                                isActive: true,
                              ),
                            );
                          });
                        },
                        icon: Icon(Icons.add_circle_outline, color: Color(0xFF68E36C)),
                        label: Text(
                          'Add Service',
                          style: TextStyle(color: Color(0xFF68E36C), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ...widget.provider.services.asMap().entries.map((entry) {
                    return _buildServiceEditCard(entry.value, entry.key);
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF68E36C), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceEditCard(Service service, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      service.price,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.isActive ? Color(0xFF68E36C).withOpacity(0.1) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        service.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          color: service.isActive ? Color(0xFF68E36C) : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: service.isActive,
                activeColor: Color(0xFF68E36C),
                onChanged: (value) {
                  setState(() {
                    service.isActive = value;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.grey[600]),
                onPressed: () {
                  _showEditServiceDialog(service);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                onPressed: () {
                  setState(() {
                    widget.provider.services.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Service deleted')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditServiceDialog(Service service) {
    final titleController = TextEditingController(text: service.title);
    final priceController = TextEditingController(text: service.price);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Service'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Service Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                service.title = titleController.text;
                service.price = priceController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF68E36C),
            ),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}