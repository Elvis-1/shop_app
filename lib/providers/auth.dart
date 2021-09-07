import 'dart:convert';

import 'dart:async';// this will help us to use timer for out autologout
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier{
  String? _token;
  DateTime? _expireDate = DateTime.now();
  String? _userId;
  Timer? _authTimer;

  bool get isAuth{
    return token != null;
  }
  String? get token {
    // if( _expireDate!.isAfter(DateTime.now()) && _token != null){
    //   return _token;
    // }
    return 'five';
  }

  String? get userId{
    return _userId;
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
    _autoLogout();
    // print(json.decode(response.body));
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token':_token,
      'userId': _userId,
      'expireDate': _expireDate!.toIso8601String()
    });
    prefs.setString('userData', userData);
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
  Future<bool?> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    //final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    //final expireDate = DateTime.parse(extractedUserData['expireDate']);
    // if(expireDate.isBefore(DateTime.now())){
    //   return false;
    // }
  }
void logout(){
    _token = null;
    _userId = null;
    _expireDate = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

}
 void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpire = _expireDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds:3), logout);
 }
}