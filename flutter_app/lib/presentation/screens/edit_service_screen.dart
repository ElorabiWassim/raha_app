import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'package:ra7a/l10n/app_localizations.dart';
import '../../data/models/serviceprovider_data.dart'; 

class EditServiceScreen extends StatefulWidget {
  final Service service;
  final String serviceId; 

  const EditServiceScreen({
    super.key,
    required this.service,
    required this.serviceId, 
  });

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  

  bool _isLoading = false;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service.title);
    _priceController = TextEditingController(text: widget.service.price);
  



    _titleController.addListener(_checkModified);
    _priceController.addListener(_checkModified);
  }

  void _checkModified() {
    setState(() {
      _isModified = _titleController.text != widget.service.title ||
          _priceController.text != widget.service.price ;
        
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveService(BuildContext context, AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      
      final updates = {
        'name': _titleController.text,
        'price_amount': double.tryParse(_priceController.text) ?? 0.0,
        
      };

      await ApiService().updateService(widget.serviceId, updates);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text(l10n.serviceAddedSuccessfully), 
            ],
          ),
          backgroundColor: Color(0xFF68E36C),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      Navigator.pop(context, true); 
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteService() async {
    
    final l10n = AppLocalizations.of(context);
    
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text(l10n.deleteService),
          ],
        ),
        content: Text(l10n.confirmDeleteService),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ApiService().deleteService(widget.serviceId);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Service deleted successfully'), backgroundColor: Colors.red),
        );
        Navigator.pop(context, true); 
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
        title: Text(l10n.editService, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _isLoading ? null : _deleteService,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              _buildServiceIcon(),
              SizedBox(height: 24),
              _buildFormSection(l10n, _isLoading),
              
              SizedBox(height: 24),
              _buildPricingGuide(l10n),
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
             BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _deleteService,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, size: 20),
                      SizedBox(width: 8),
                      Text(l10n.delete, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || !_isModified
                      ? null
                      : () => _saveService(context, l10n),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF68E36C),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: _isLoading
                      ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(l10n.saveChanges, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  
  Widget _buildServiceIcon() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF68E36C), Color(0xFF5CD660)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Color(0xFF68E36C).withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
        ),
        child: Icon(Icons.build_circle_outlined, size: 60, color: Colors.white),
      ),
    );
  }

  Widget _buildFormSection(AppLocalizations l10n, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.serviceDetails, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            enabled: !isLoading,
            validator: (value) => (value == null || value.isEmpty) ? l10n.enterServiceTitle : null,
            decoration: InputDecoration(
              labelText: l10n.serviceTitle,
              prefixIcon: Icon(Icons.title, color: Color(0xFF68E36C)),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF68E36C), width: 2)),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            enabled: !isLoading,
            validator: (value) => (value == null || value.isEmpty) ? l10n.enterServicePrice : null,
            decoration: InputDecoration(
              labelText: l10n.price,
              prefixIcon: Icon(Icons.attach_money, color: Color(0xFF68E36C)),
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF68E36C), width: 2)),
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildPricingGuide(AppLocalizations l10n) {
     return Container(
       margin: EdgeInsets.symmetric(horizontal: 16),
       padding: EdgeInsets.all(20),
       decoration: BoxDecoration(
         gradient: LinearGradient(colors: [Color(0xFF68E36C).withValues(alpha: 0.15), Color(0xFF68E36C).withValues(alpha: 0.05)]),
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: Color(0xFF68E36C).withValues(alpha: 0.3)),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(children: [Icon(Icons.lightbulb_outline, color: Color(0xFF68E36C), size: 24), SizedBox(width: 12), Text(l10n.pricingTips, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D7A30)))]),
           SizedBox(height: 12),
           _buildTipItem(l10n.tipClearPricing),
           _buildTipItem(l10n.tipStartingPrices),
         ],
       ),
     );
  }
  
  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Color(0xFF68E36C), size: 16),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Color(0xFF2D7A30), height: 1.4))),
        ],
      ),
    );
  }
}