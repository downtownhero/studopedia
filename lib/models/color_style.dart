import 'package:flutter/material.dart';

const kButtonColor = Color(0xFFE34E20);
const kSecondaryColor = Color(0xFF171D5F);
LinearGradient kLinearGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [
    0.35,
    0.7,
  ],
  colors: [
    Color(0xFF0D113E),
    kSecondaryColor,
  ],
);
