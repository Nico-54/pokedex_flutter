import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'feu':
      return Colors.red;
    case 'eau':
      return Colors.blue;
    case 'plante':
      return Colors.green;
    case 'electrik':
      return Colors.yellow;
    case 'psy':
      return Colors.pink;
    case 'roche':
      return Colors.brown;
    case 'sol':
      return Colors.orange;
    case 'vol':
      return Colors.blue.shade200;
    case 'ténébres':
      return Colors.black;
    case 'dragon':
      return Colors.indigo;
    case 'acier':
      return Colors.grey;
    case 'poison':
      return Colors.purpleAccent;
    case 'combat':
      return Colors.deepOrangeAccent;
    case 'glace':
      return Colors.cyan;
    case 'fée':
      return Colors.pinkAccent;
    case 'normal':
      return Colors.grey.shade400;
    case 'insecte':
      return Colors.lightGreen;
    case 'spectre':
      return Colors.purple;
    default:
      return Colors.black; // Par défaut, noir si le type n'est pas reconnu
  }
}
