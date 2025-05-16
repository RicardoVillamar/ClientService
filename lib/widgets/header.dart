import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double screenHeight = 0.0;
  final String nombre = 'Usuario';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hola! $nombre',
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 3),
                        blurRadius: 5,
                      )
                    ]),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  color: Colors.black,
                  iconSize: 25,
                  onPressed: () => {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  color: Colors.black,
                  iconSize: 25,
                  onPressed: () => {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
