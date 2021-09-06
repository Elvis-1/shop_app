import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier{
  String _token = '';
  DateTime _expireDate = DateTime.now();
  String _userId = '';

  bool get isAuth{
    return token != '';
  }
  String get token {
    if( _expireDate.isAfter(DateTime.now()) && _token != ''){
      return _token;
    }
    return '';
  }
  //Auth(this._token, this._expireDate, this._userId);
 // To use auth, go to firebase auth api, also note that for more secured authentication, use firebase docs or take a course on it
Future<void> _authenticate(String email, String password, String urlSegment) async{
  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBJ3t8Wxj0YhgZFyIlIsgqeTT_AAYrVaKI';
  try{
    final response = await http.post(Uri.parse(url), body:json.encode(
        {
          'email':email,
          'password':password,
          'returnSecureToken' : true
        }
    ) );
    final responseData = json.decode(response.body);
    if(responseData['error'] != null){
      throw HttpException(responseData['error']['message']); // throwing it makes it available in the screen where it is used
    }
    _token = responseData['idToken'] ;//= idToken is the way it is represented in firebase official docs and its a requirement to authenticate users
    _userId = responseData['localId']; // Local id is also represented in firebase official docs;
    _expireDate = DateTime.now().add(Duration(
      seconds: int.parse(responseData['expiresIn'])
    ));
    // print(json.decode(response.body));
    notifyListeners();
  }catch(error){
    throw error;
  }


}
  Future<void> signUp(String email, String password) async{
  return _authenticate(email, password, 'signUp');
    // go to project settings in your firebase app and get your api key
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBJ3t8Wxj0YhgZFyIlIsgqeTT_AAYrVaKI';
    // in firebase auth rest api, you will also see how to construct the body of your request. 
   // final response = await http.post(Uri.parse(url), body:json.encode(
   //      {
   //        'email':email,
   //        'password':password,
   //        'returnSecureToken' : true
   //      }
   //      ) );
   //   print(json.decode(response.body));
  }
  Future<void> login(String email, String password) async{
  return _authenticate(email, password, 'signInWithPassword');
  }
    // go to project settings in your firebase app and get your api key
    // const url =
    // 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBJ3t8Wxj0YhgZFyIlIsgqeTT_AAYrVaKI';
  //   final response = await http.post(Uri.parse(url), body:json.encode(
  //       {
  //         'email':email,
  //         'password':password,
  //         'returnSecureToken' : true
  //       }
  //   ) );
  //   print(json.decode(response.body));
  // }

}