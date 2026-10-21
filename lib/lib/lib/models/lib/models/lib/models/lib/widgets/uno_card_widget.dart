import 'package:flutter/material.dart';
import '../models/card.dart';

class UnoCardWidget extends StatelessWidget {
  final UnoCard card;
  final VoidCallback? onTap;
  final double width;

  const UnoCardWidget({super.key, required this.card, this.onTap, this.width = 70});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: width * 1.5,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: card.uiColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(1, 2))],
        ),
        child: Center(
          child: Text(
            card.display,
            style: TextStyle(
              fontSize: width * 0.45,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2)],
            ),
          ),
        ),
      ),
    );
  }
}
