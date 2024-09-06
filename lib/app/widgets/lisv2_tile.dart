import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style/app_color.dart';

class Lisv2Tile extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget trailing; // Tambahkan properti trailing

  Lisv2Tile({
    required this.title,
    required this.icon,
    required this.trailing, // Inisialisasi trailing
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing, // Tambahkan trailing di sini
          ],
        ),
      ),
    );
  }
}
