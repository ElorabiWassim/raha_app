import 'package:flutter/material.dart';
import '../widgets/question_demand.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';
import '../widgets/elevatedButton.dart';

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
  List<String> categories = [
    'Cleaning',
    'Plumbing',
    'Electrical',
    'Gardening',
    'Handyman',
    'Painting',
    'Moving',
  ];

  String? selectedCategory;
  void onPressSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }

    //we will add the business logic later .
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            'Add New Demand',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF51B035)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionDemand(question: "Where the service is needed ?"),
              TextFormField(
                cursorColor: Colors.black,
                controller: addressController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Enter your adress',
                  labelStyle: TextStyle(color: Color(0xFF1E293B)),
                  hintText: 'Enter your adress',
                  hintStyle: TextStyle(color: Color(0xFFB8B9B9)),
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              SizedBox(height: 12),
              QuestionDemand(question: "What is the type of the service ?"),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Color(0xFF1E293B)),
                  prefixIcon: Icon(Icons.category, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items:
                    categories //this is just for the categories list
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedCategory = val),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 12),
              QuestionDemand(question: "What is the title of this service ?"),
              TextFormField(
                cursorColor: Colors.black,
                controller: serviceTitleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Color(0xFF1E293B)),
                  hintText: 'Enter the title of the service',
                  hintStyle: TextStyle(color: Color(0xFFB8B9B9)),
                  prefixIcon: Icon(Icons.assignment, color: Color(0xFF53B538)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionDemand(question: 'Date'),
                      SimpleDatePicker(),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionDemand(question: 'Time'),
                      TimePickerField(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              QuestionDemand(question: 'Description'),

              TextFormField(
                minLines: 1,
                maxLines: 7,
                cursorColor: Colors.black,
                controller: descriptionController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: Color(0xFF1E293B)),
                  hintText: 'Describe the service you need \n \n  ',
                  hintStyle: TextStyle(color: Color(0xFFB8B9B9)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF53B538), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 15),
              btn(onPressSubmit, "Post"),
            ],
          ),
        ),
      ),
    );
  }
}
