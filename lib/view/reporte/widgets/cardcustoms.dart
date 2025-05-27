import 'package:flutter/material.dart';

class CardIMG extends StatefulWidget {
  final Icon icon;
  final Function()? onPressed;
  final bool showIcon;

  const CardIMG({
    super.key,
    required this.icon,
    this.onPressed,
    this.showIcon = true,
  });

  @override
  State<CardIMG> createState() => _CardIMGState();
}

class _CardIMGState extends State<CardIMG> {
  final String title = "Titulo1";
  final String subtitle = "Subtitulo2Subtitulo2";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: Image.asset(
              'assets/images/Clientes.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
              ],
            ),
          ),
          Visibility(
            visible: widget.showIcon,
            child: IconButton(
              onPressed: widget.onPressed,
              icon: widget.icon,
            ),
          ),
        ],
      ),
    );
  }
}

class CardTXT extends StatefulWidget {
  final Icon icon;
  final Function()? onPressed;
  final bool showIcon;

  const CardTXT({
    super.key,
    required this.icon,
    this.onPressed,
    this.showIcon = true,
  });

  @override
  State<CardTXT> createState() => _CardTXTState();
}

class _CardTXTState extends State<CardTXT> {
  final String title = "Titulo1";
  final String subtitle = "Subtitulo2Subtitulo2";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
                Text("$title: $subtitle"),
              ],
            ),
          ),
          Visibility(
            visible: widget.showIcon,
            child: IconButton(
              onPressed: widget.onPressed,
              icon: widget.icon,
            ),
          ),
        ],
      ),
    );
  }
}
