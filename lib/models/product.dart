import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/utils/constants.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {this.isFavorite = false,
      required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl});

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String uId) async {
    try {
      _toggleFavorite();
      String baseUrl = Constantst.userFavoritesUrl;
      final response = await http.put(
        Uri.parse('$baseUrl/$uId/$id.json?auth=$token'),
        body: jsonEncode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (e) {
      _toggleFavorite();
    }
  }
}
