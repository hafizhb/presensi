import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style/app_color.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool disabled;
  final EdgeInsetsGeometry margin;
  final bool obsecureText;
  final Widget? suffixIcon;
  CustomInput({
    required this.controller,
    required this.label,
    required this.hint,
    this.disabled = false,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.obsecureText = false,
    this.suffixIcon,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    print("builded");
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 14, right: 14, top: 4),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: (widget.disabled == false) ? Colors.transparent : AppColor.primarySoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: AppColor.secondary),
        ),
        child: TextField(
          readOnly: widget.disabled,
          obscureText: widget.obsecureText,
          style: GoogleFonts.poppins(fontSize: 14),
          maxLines: 1,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: widget.suffixIcon ?? SizedBox(),
            label: Text(
              widget.label,
              style: GoogleFonts.poppins(
                color: AppColor.blackprimary,
                fontSize: 14,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.blacksecondary,
            ),
          ),
        ),
      ),
    );
  }
}