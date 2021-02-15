import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function onChanged;
  final Function validator;
  final String hintText;
  final String labelText;
  final String initialValue;

  const CustomTextField(
      {Key key,
      this.onChanged,
      this.hintText,
      this.initialValue = '',
      this.validator,
      this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.number,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.black54,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
