import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.labelText,
    required this.validator,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  final String labelText;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            size: 22,
          ),
          onPressed: _toggleVisibility,
        )
            : null,
      ),
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
    );
  }
}
