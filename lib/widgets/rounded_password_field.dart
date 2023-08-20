import 'package:flutter/material.dart';
import 'package:studopedia/models/color_style.dart';
import 'login_text_field.dart';

class RoundedPasswordField extends StatefulWidget {
  final Function onChanged;
  final Key formKey;
  RoundedPasswordField({this.onChanged, @required this.formKey});
  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return LoginTextField(
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          validator: (value) => value.length < 6
              ? 'Password must be at least 6 characters'
              : null,
          autofocus: false,
          onChanged: widget.onChanged,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Your Password',
            icon: Icon(
              Icons.lock,
              color: kSecondaryColor,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
              ),
              color: obscure ? Colors.grey[600] : kSecondaryColor,
              onPressed: () {
                setState(() {
                  obscure ? obscure = false : obscure = true;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
