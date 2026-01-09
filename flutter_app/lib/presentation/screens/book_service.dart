import 'package:flutter/material.dart';
import '../widgets/question_demand.dart';
import '../widgets/date_picker.dart';
import '../widgets/time_picker.dart';
import '../widgets/elevatedButton.dart';
import '../widgets/service_card.dart';
import '../../cubits/booking_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class BookService extends StatefulWidget {
  final String service_name;
  final String serviceId;
  final String spId;
  const BookService({
    super.key,
    required this.service_name,
    required this.serviceId,
    required this.spId,
  });
  @override
  State<BookService> createState() => _BookService();
}

class _BookService extends State<BookService> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  late DateTime selectedDate;
  late String selectedTime;
  List<File> selectedImages = [];

  Future<void> onPressSubmit() async {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<BookServiceCubit>();

      final prefs = await SharedPreferences.getInstance();
      final homeownerIdv = prefs.getString('user_id');
      if (homeownerIdv == null || homeownerIdv.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please login first.')));
        return;
      }

      if (widget.serviceId.isEmpty || widget.spId.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing service/provider id.')),
        );
        return;
      }

      final photos = selectedImages.map((file) => file.path).toList();
      final request = BookServiceRequest(
        description: descriptionController.text.trim(),
        serviceId: widget.serviceId,
        homeownerId: homeownerIdv,
        spId: widget.spId,
        date: selectedDate.toIso8601String(),
        time: selectedTime,
        location: addressController.text.trim(),
        photosPaths: photos,
      );

      await cubit.bookService(request);
      if (!mounted) return;

      final state = cubit.state;
      if (state is BookServiceSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service booked successfully!')),
        );
      } else if (state is BookServiceFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.message.isEmpty ? 'Failed to book service' : state.message,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to book service')));
      }
    }
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) return;
    setState(() {
      selectedImages = images.map((img) => File(img.path)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            'Book Service',
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
              ServiceCard(
                title: widget.service_name,
                subtitle: "Service Selected",
                icon: Icons.build,
              ),
              SizedBox(height: 12),
              QuestionDemand(question: 'What do you need to be done ?'),

              TextFormField(
                minLines: 1,
                maxLines: 7,
                cursorColor: Colors.black,
                controller: descriptionController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(color: Color(0xFF1E293B)),
                  hintText: 'Describe the service you need \n \n \n  ',
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
              SizedBox(height: 10),
              btn2(pickImages, "Add Photos"),
              SizedBox(height: 10),
              QuestionDemand(question: "When do you need the service ?"),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleDatePicker(
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimePickerField(
                          onTimeSelected: (time) {
                            setState(() {
                              selectedTime = time;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
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

              SizedBox(height: 40),
              btn(() => onPressSubmit(), "Book Service"),
            ],
          ),
        ),
      ),
    );
  }
}
