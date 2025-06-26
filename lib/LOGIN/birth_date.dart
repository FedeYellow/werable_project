import 'package:flutter/material.dart';

class BirthDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const BirthDatePicker({super.key, required this.onDateSelected});

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked); // Enviamos la fecha al padre
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDate == null
              ? 'Select birth date'
              : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        ),
        TextButton(
          onPressed: () => _pickDate(context),
          child: const Text('Choose'),
        ),
      ],
    );
  }
}
