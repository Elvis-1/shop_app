import 'package:flutter/foundation.dart';
import 'dart:convert'; // import this to convert to json
import 'package:http/http.dart' as http;


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
  required this.title,
  required this.description,
  required this.price,
  required this.imageUrl,
    this.isFavorite = false
  });

  Future<void> toggleFavorite(String? token, String? userId) async{
  final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
  final url = 'https://myapp-a30dc.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
  try{
  final response = await  http.patch(Uri.parse(url), body: json.encode( // import 'dart:convert'; import this to use json.encode to json
      isFavorite,
    ));
  if(response.statusCode >= 400){
    isFavorite = oldStatus;
    notifyListeners();
  }
  }catch(error){
  isFavorite = oldStatus;
  notifyListeners();
  }

  }

}