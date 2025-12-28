// lib/presentation/screens/add_service_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'package:ra7a/l10n/app_localizations.dart';

class AddServiceScreen extends StatefulWidget {
  final VoidCallback? onServiceAdded;

  const AddServiceScreen({super.key, this.onServiceAdded});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedCategory = 'Plumbing';
  String _selectedPricingModel = 'Fixed Price';
  List<XFile> _selectedImages = [];
  bool _isUploading = false;

  final List<String> _categories = [
    'Plumbing',
    'Electrical',
    'Carpentry',
    'Cleaning',
    'Painting',
  ];

  @override
  void dispose() {
    _serviceNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Helper: Convert XFile to MultipartFile
  Future<http.MultipartFile> _fileToMultipart(XFile file) async {
    final bytes = await file.readAsBytes();
    return http.MultipartFile.fromBytes(
      'images', // Must match backend: upload.array('images', 10)
      bytes,
      filename: file.name,
    );
  }

  String? _getCategoryIdByName(String name) {
    const Map<String, String> categoryMap = {
      'Plumbing': 'a75af59d-3e61-402d-9bd2-54a5e64fc950',
      'Electrical': '2',
      'Carpentry': '3',
      'Cleaning': '4',
      'Painting': '5',
    };
    return categoryMap[name];
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _addService(AppLocalizations l10n) async {
    if (_serviceNameController.text.isEmpty) {
      return _showError(l10n.pleaseEnterServiceName);
    }
    if (_descriptionController.text.isEmpty) {
      return _showError(l10n.pleaseEnterDescription);
    }
    if (_priceController.text.isEmpty) {
      return _showError(l10n.pleaseEnterPrice);
    }

    double priceAmount;
    try {
      priceAmount = double.parse(_priceController.text);
    } catch (e) {
      return _showError(l10n.pleaseEnterPrice);
    }

    final categoryId = _getCategoryIdByName(_selectedCategory);
    if (categoryId == null) {
      return _showError('Invalid category');
    }

    final priceType = _selectedPricingModel == l10n.fixedPrice ? 'fixed' : 'hourly';

    setState(() => _isUploading = true);

    try {
      // STEP 1: Create the service
      final serviceId = await ApiService().addService(
        name: _serviceNameController.text,
        description: _descriptionController.text,
        categoryId: categoryId,
        priceType: priceType,
        priceAmount: priceAmount,
      );

      // STEP 2: Upload images (if any)
      if (_selectedImages.isNotEmpty) {
        final multipartFiles = await Future.wait(
          _selectedImages.map((img) => _fileToMultipart(img)),
        );
        await ApiService().uploadServiceImages(
          serviceId: serviceId,
          images: multipartFiles,
        );
      }

      // Notify parent to refresh
      widget.onServiceAdded?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.serviceAddedSuccessfully),
          backgroundColor: Color(0xFF68E36C),
        ),
      );
      Navigator.pop(context);

    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.addService,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(l10n),
              if (_selectedImages.isNotEmpty) ...[
                SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (_, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(_selectedImages[i].path), height: 100, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 32),
              _buildServiceDetailsSection(l10n),
              SizedBox(height: 32),
              _buildPricingSection(l10n),
              SizedBox(height: 40),
              _buildButtons(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.serviceImages,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(
          l10n.addPhotosToAttractCustomers,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final picker = ImagePicker();
            final images = await picker.pickMultiImage();
            setState(() {
              _selectedImages = images;
            });
                    },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, size: 48, color: Color(0xFF68E36C)),
                SizedBox(height: 16),
                Text(
                  l10n.uploadImages,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  l10n.tapToSelectFromGallery,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  

  Widget _buildServiceDetailsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.serviceDetails,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 16),
        _buildInputField(
          label: l10n.serviceName,
          controller: _serviceNameController,
          hint: l10n.enterServiceName,
        ),
        SizedBox(height: 20),
        _buildInputField(
          label: l10n.description,
          controller: _descriptionController,
          maxLines: 4,
          hint: l10n.describeYourService,
        ),
        SizedBox(height: 20),
        _buildCategoryDropdown(l10n),
      ],
    );
  }

  Widget _buildCategoryDropdown(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            items: _categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pricing,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 16),
        _buildPricingModelButtons(l10n),
        SizedBox(height: 20),
        _buildPriceField(l10n),
      ],
    );
  }

  Widget _buildPricingModelButtons(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.pricingModel,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildPricingModelButton(
                l10n.hourlyRate,
                _selectedPricingModel == l10n.hourlyRate,
                l10n,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildPricingModelButton(
                l10n.fixedPrice,
                _selectedPricingModel == l10n.fixedPrice,
                l10n,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingModelButton(String label, bool isSelected, AppLocalizations l10n) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPricingModel = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF68E36C).withValues(alpha: .1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF68E36C) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Color(0xFF68E36C) : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.price,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(fontSize: 15, color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: l10n.enterPrice,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                widthFactor: 0.0,
                child: Text(
                  'DA',
                  style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF68E36C), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isUploading ? null : () => _addService(l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF68E36C),
              padding: EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isUploading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    l10n.addService,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.cancel,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(fontSize: 15, color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF68E36C), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}