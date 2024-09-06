import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style/app_color.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;
  MenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColor.primary,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              margin: EdgeInsets.only(right: 24),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primarySoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: AppColor.blacksecondary,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 24),
              child: Icon(Icons.arrow_forward,
                color: AppColor.blacksecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}