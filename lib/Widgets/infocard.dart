import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class infoCard extends StatelessWidget {
  final VoidCallback onpress;
  final String name;
  final IconData icon;
  final String company;
  late var Prof_icon;
  final String initial;

  infoCard({
    this.icon = Icons.person,
    required this.name,
    required this.company,
    required this.onpress,
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    if (this.name == "") {
      Prof_icon = Icon(Icons.person);
    } else {
      Prof_icon = Text(
        '$initial',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      );
    }

    return GestureDetector(
      onTap: onpress,
      child: Material(
        elevation: 6, // Add elevation to the whole container
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Prof_icon,
                    backgroundColor: Color(0xffa4392f),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${this.name}',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${this.company}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
