import 'package:flutter/material.dart';

class Cardcustom extends StatefulWidget {
  final Icon icon;
  final Function()? onPressed;
  final bool showIcon;
  const Cardcustom({
    super.key,
    required this.icon,
    this.onPressed,
    this.showIcon = true,
  });

  @override
  State<Cardcustom> createState() => _CardcustomState();
}

class _CardcustomState extends State<Cardcustom> {
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
            offset: Offset(0, 2), // changes position of shadow
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
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(),
                child: const Text("Card Description",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
            ],
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
