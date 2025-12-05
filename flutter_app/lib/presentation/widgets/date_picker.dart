import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleDatePicker extends StatefulWidget {
  const SimpleDatePicker({super.key});

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  DateTime? selectedDate;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today.add(const Duration(days: 0)),
      firstDate: today.add(const Duration(days: 0)),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF73BF60),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        _controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          labelText: 'Select a date',
          labelStyle: TextStyle(color: Colors.black),
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: Color(0xFF73BF60),
          ),
          suffixIcon: const Icon(
            Icons.edit_calendar_outlined,
            color: Color(0xFF73BF60),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF73BF60), width: 2),
          ),
        ),
      ),
    );
  }
}
