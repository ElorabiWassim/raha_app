import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ra7a/core/location/location_picker_screen.dart';
import 'package:ra7a/core/location/location_service.dart';
import '../../data/models/serviceprovider_data.dart';
import '../../services/api_service.dart';
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
  late TextEditingController _locationController;
  late TextEditingController _experienceController;

  bool _isModified = false;
  bool _isLoading = false;
  XFile? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.provider.name);

    _locationController = TextEditingController(text: widget.provider.location);
    _experienceController = TextEditingController(
      text: widget.provider.experience,
    );

    _nameController.addListener(_checkModified);
    _locationController.addListener(_checkModified);
    _experienceController.addListener(_checkModified);
  }

  void _checkModified() {
    setState(() {
      _isModified =
          _nameController.text != widget.provider.name ||
          _locationController.text != widget.provider.location ||
          _experienceController.text != widget.provider.experience ||
          _selectedImage != null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = image;
          _selectedImageBytes = bytes;
          _checkModified();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final api = ApiService();

      // 1. Update Text Details
      await api.updateProfile(
        name: _nameController.text,

        location: _locationController.text,
        experience: _experienceController.text,
      );

      // 2. Update Image if selected
      if (_selectedImage != null) {
        await api.updateProfilePicture(_selectedImage!);
        print('image mounted');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Profile updated successfully'),
            ],
          ),
          backgroundColor: Color(0xFF68E36C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.pop(context, true); // Return true to refresh parent
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error: ${e.toString().replaceAll('Exception:', '')}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _setLocationFromCurrentPosition() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final pos = await LocationService().getCurrentPosition();
      final picked = await LocationService().reverseGeocode(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      if (!mounted) return;
      _locationController.text = picked.displayAddress;
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _setLocationFromMap() async {
    if (_isLoading) return;
    final picked = await Navigator.push<PickedLocation>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
    if (!mounted || picked == null) return;
    _locationController.text = picked.displayAddress;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 24),
              _buildProfileAvatar(),
              SizedBox(height: 32),
              _buildFormSection(l10n),
              SizedBox(height: 32),
              _buildStatsInfo(l10n),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
            onPressed: _isLoading || !_isModified ? null : _saveProfile,
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
            child: _isLoading
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Stack(
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

              backgroundImage: _selectedImageBytes != null
                  ? MemoryImage(_selectedImageBytes!)
                  : (widget.provider.profileImageUrl != null &&
                        widget.provider.profileImageUrl!.isNotEmpty)
                  ? NetworkImage(widget.provider.profileImageUrl!)
                        as ImageProvider
                  : null,
              child:
                  (_selectedImageBytes == null &&
                      (widget.provider.profileImageUrl == null ||
                          widget.provider.profileImageUrl!.isEmpty))
                  ? Icon(Icons.person, size: 60, color: Color(0xFF68E36C))
                  : null,
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
      ),
    );
  }

  Widget _buildFormSection(AppLocalizations l10n) {
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
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _locationController,
            label: l10n.location,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _setLocationFromCurrentPosition,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF68E36C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: Icon(Icons.my_location, color: Color(0xFF68E36C)),
                  label: Text(
                    'Use current location',
                    style: TextStyle(color: Color(0xFF68E36C)),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _setLocationFromMap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF68E36C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: Icon(Icons.map_outlined, color: Color(0xFF68E36C)),
                  label: Text(
                    'Pick on map',
                    style: TextStyle(color: Color(0xFF68E36C)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
            controller: _experienceController,
            label: l10n.experience,
            icon: Icons.timeline_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_isLoading,
      validator:
          validator ??
          (val) => (val == null || val.isEmpty) ? 'Required' : null,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildStatsInfo(AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF68E36C).withValues(alpha: 0.1),
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
          _buildStatRow(
            Icons.rate_review,
            '${widget.provider.reviewCount}',
            l10n.reviews,
          ),
          SizedBox(height: 12),
          _buildStatRow(
            Icons.check_circle,
            widget.provider.jobsDone,
            l10n.jobsDone,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF68E36C), size: 20),
        SizedBox(width: 12),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
