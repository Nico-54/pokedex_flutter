import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'fire':
      return Colors.red;
    case 'water':
      return Colors.blue;
    case 'grass':
      return Colors.green;
    case 'electric':
      return Colors.yellow;
    case 'psychic':
      return Colors.pinkAccent;
    case 'rock':
      return Colors.brown;
    case 'ground':
      return Colors.orange;
    case 'flying':
      return Colors.blue.shade200;
    case 'dark':
      return Colors.black;
    case 'dragon':
      return Colors.indigo;
    case 'steel':
      return Colors.grey;
    case 'poison':
      return Colors.purpleAccent;
    case 'fighting':
      return Colors.deepOrangeAccent;
    case 'ice':
      return Colors.cyan;
    case 'fairy':
      return Colors.pinkAccent;
    case 'normal':
      return Colors.grey.shade400;
    case 'bug':
      return Colors.lightGreen;
    case 'ghost':
      return Colors.purple;
    default:
      return Colors.black; // Par défaut, noir si le type n'est pas reconnu
  }
}
