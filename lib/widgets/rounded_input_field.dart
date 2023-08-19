import 'package:flutter/material.dart';
import 'package:studopedia/models/color_style.dart';
import 'login_text_field.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final Function onChanged;
  final TextInputType keyboardType;
  final Function validator;
  final Key formKey;
  final TextCapitalization textCapitalization;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.keyboardType,
    this.validator,
    @required this.formKey,
    this.textCapitalization,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return LoginTextField(
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          autofocus: false,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            icon: Icon(
              widget.icon,
              color: kSecondaryColor,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
