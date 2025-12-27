import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/question_demand.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';
import '../widgets/elevatedButton.dart';
// Ensure this import points to your generated localizations file
import 'package:ra7a/l10n/app_localizations.dart';
import '../../cubits/demands_cubits.dart';

class AddDemand extends StatefulWidget {
  const AddDemand({super.key});
  @override
  State<AddDemand> createState() => _AddDemand();
}

class _AddDemand extends State<AddDemand> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  String? selectedTime;
  String? selectedCategory;

  void onPressSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<AddDemandCubit>();

      try {
        await cubit.addDemand(
          homeownerId: "5cc32637-3714-416d-ac57-177e353ca30d",
          categoryName: selectedCategory!,
          title: serviceTitleController.text,
          location: addressController.text,
          date: selectedDate!.toIso8601String(),
          time: selectedTime!,
          description: descriptionController.text,
        );

        if (!mounted) return;
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.msgDemandAddedSuccess)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.msgDemandAddedFail(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access localizations
    final l10n = AppLocalizations.of(context)!;

    // Map for Categories: Key (Backend value) -> Value (Display text)
    final Map<String, String> categoryMap = {
      'Cleaning': l10n.catCleaning,
      'Plumbing': l10n.catPlumbing,
      'Electrical': l10n.catElectrical,
      'Gardening': l10n.catGardening,
      'Handyman': l10n.catHandyman,
      'Painting': l10n.catPainting,
      'Moving': l10n.catMoving,
    };

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            l10n.titleAddDemand,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF51B035)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionDemand(question: l10n.questionLocation),
              TextFormField(
                cursorColor: Colors.black,
                controller: addressController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: l10n.labelAddress,
                  labelStyle: const TextStyle(color: Color(0xFF1E293B)),
                  hintText: l10n.hintAddress,
                  hintStyle: const TextStyle(color: Color(0xFFB8B9B9)),
                  prefixIcon: const Icon(Icons.location_on, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? l10n.errorAddress : null,
              ),
              const SizedBox(height: 12),
              
              QuestionDemand(question: l10n.questionCategory),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: l10n.labelCategory,
                  labelStyle: const TextStyle(color: Color(0xFF1E293B)),
                  prefixIcon: const Icon(Icons.category, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: categoryMap.entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key, // Keeps English value for Backend
                          child: Text(entry.value), // Shows Localized text
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                validator: (value) =>
                    value == null ? l10n.errorCategory : null,
              ),
              const SizedBox(height: 12),

              QuestionDemand(question: l10n.questionServiceTitle),
              TextFormField(
                cursorColor: Colors.black,
                controller: serviceTitleController,
                decoration: InputDecoration(
                  labelText: l10n.labelTitle,
                  labelStyle: const TextStyle(color: Color(0xFF1E293B)),
                  hintText: l10n.hintTitle,
                  hintStyle: const TextStyle(color: Color(0xFFB8B9B9)),
                  prefixIcon: const Icon(Icons.assignment, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? l10n.errorTitle : null,
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuestionDemand(question: l10n.labelDate),
                        SimpleDatePicker(
                          onDateSelected: (date) {
                            setState(() {
                              selectedDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionDemand(question: l10n.labelTime),
                      TimePickerField(
                        onTimeSelected: (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              QuestionDemand(question: l10n.questionDescription),
              TextFormField(
                minLines: 1,
                maxLines: 7,
                cursorColor: Colors.black,
                controller: descriptionController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: const TextStyle(color: Color(0xFF1E293B)),
                  hintText: l10n.hintDescription,
                  hintStyle: const TextStyle(color: Color(0xFFB8B9B9)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? l10n.errorDescription : null,
              ),
              const SizedBox(height: 15),
              btn(onPressSubmit, l10n.btnPost),
            ],
          ),
        ),
      ),
    );
  }
}