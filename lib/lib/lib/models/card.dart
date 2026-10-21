import 'package:flutter/material.dart';

enum CardColor { red, yellow, green, blue, wild }
enum CardType { number, skip, reverse, drawTwo, wild, wildDrawFour }

class UnoCard {
  final CardColor color;
  final CardType type;
  final int? number;
  final String id;
  CardColor? chosenColor;

  UnoCard({required this.color, required this.type, this.number, required this.id, this.chosenColor});

  CardColor get effectiveColor =>
      color == CardColor.wild ? (chosenColor ?? CardColor.wild) : color;

  String get display {
    switch (type) {
      case CardType.number: return '$number';
      case CardType.skip: return '🚫';
      case CardType.reverse: return '🔄';
      case CardType.drawTwo: return '+2';
      case CardType.wild: return '🌈';
      case CardType.wildDrawFour: return '+4';
    }
  }

  Color get uiColor {
    switch (effectiveColor) {
      case CardColor.red: return Colors.red.shade700;
      case CardColor.yellow: return Colors.amber.shade600;
      case CardColor.green: return Colors.green.shade700;
      case CardColor.blue: return Colors.blue.shade700;
      case CardColor.wild: return Colors.purple.shade700;
    }
  }

  bool canPlayOn(UnoCard top) {
    if (color == CardColor.wild) return true;
    if (top.color == CardColor.wild) {
      return color == top.chosenColor || type == top.type;
    }
    return color == top.color ||
        (type == CardType.number && top.type == CardType.number && number == top.number) ||
        (type != CardType.number && type == top.type);
  }
}
