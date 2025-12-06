// Save this file as: lib/presentation/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/serviceprovider_data.dart';
import '../../cubits/serviceprovider_cubit.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  final ServiceProvider provider;

  const EditProfileScreen({super.key, required this.provider});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _professionController;
  late TextEditingController _locationController;
  late TextEditingController _experienceController;
  
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider.name);
    _professionController = TextEditingController(text: widget.provider.profession);
    _locationController = TextEditingController(text: widget.provider.location);
    _experienceController = TextEditingController(text: widget.provider.experience);
    
    _nameController.addListener(_checkModified);
    _professionController.addListener(_checkModified);
    _locationController.addListener(_checkModified);
    _experienceController.addListener(_checkModified);
  }
  
  void _checkModified() {
    setState(() {
      _isModified = _nameController.text != widget.provider.name ||
          _professionController.text != widget.provider.profession ||
          _locationController.text != widget.provider.location ||
          _experienceController.text != widget.provider.experience;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ServiceProviderCubit>().updateProfile(
        name: _nameController.text,
        profession: _professionController.text,
        location: _locationController.text,
        experience: _experienceController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<ServiceProviderCubit, ServiceProviderState>(
      listener: (context, state) {
        if (state is ServiceProviderUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text(state.message),
                ],
              ),
              backgroundColor: Color(0xFF68E36C),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is ServiceProviderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF68E36C), Color(0xFF5CD660)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.editProfile,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
          builder: (context, state) {
            bool isLoading = state is ServiceProviderUpdating;
            
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    _buildProfileAvatar(),
                    SizedBox(height: 32),
                    _buildFormSection(l10n, isLoading),
                    SizedBox(height: 32),
                    _buildStatsInfo(l10n),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<ServiceProviderCubit, ServiceProviderState>(
          builder: (context, state) {
            bool isLoading = state is ServiceProviderUpdating;
            
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: isLoading || !_isModified ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF68E36C),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF68E36C).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 60, color: Color(0xFF68E36C)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF68E36C),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(AppLocalizations l10n, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileInformation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _nameController,
            label: l10n.name,
            icon: Icons.person_outline,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _professionController,
            label: l10n.profession,
            icon: Icons.work_outline,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your profession';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _locationController,
            label: l10n.location,
            icon: Icons.location_on_outlined,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your location';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _experienceController,
            label: l10n.experience,
            icon: Icons.timeline_outlined,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your experience';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF68E36C)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF68E36C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildStatsInfo(AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF68E36C).withValues(alpha: 0.1), Color(0xFF5CD660).withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF68E36C).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsInformation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildStatRow(Icons.star, '${widget.provider.rating}', l10n.rating),
          SizedBox(height: 12),
          _buildStatRow(Icons.rate_review, '${widget.provider.reviewCount}', l10n.reviews),
          SizedBox(height: 12),
          _buildStatRow(Icons.check_circle, widget.provider.jobsDone, l10n.jobsDone),
          SizedBox(height: 12),
          _buildStatRow(Icons.schedule, widget.provider.responseTime, l10n.responseTime),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF68E36C).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF68E36C), size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}