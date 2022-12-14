import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier{
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebaseToken = "AIzaSyA7A-FDNlj9UH2I2jXMXW6bj5CxaV_xiX8";
  final storage = new FlutterSecureStorage();

  //Si retornamos algo es un error, sino todo bien
  Future<String?> createUser(String email, String password) async{
    final Map<String, dynamic> authData = {
      'email': email,
      'password':password,
      'returnSecureToken': true
    };
    
    final url = Uri.https(_baseUrl,'/v1/accounts:signUp',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    
    if(decodeResp.containsKey('idToken')){
      storage.write(key: 'token', value: decodeResp['idToken']);
      //Token hay que guardarlo en un lugar seguro
      return null;
    }else{
      return decodeResp['error']['message'];
    }
  }

  Future<String?> loginUser(String email, String password) async{
    final Map<String, dynamic> authData = {
      'email': email,
      'password':password,
      'returnSecureToken': true
    };
    
    final url = Uri.https(_baseUrl,'/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    if(decodeResp.containsKey('idToken')){
      //Token hay que guardarlo en un lugar seguro
      storage.write(key: 'token', value: decodeResp['idToken']);
      return null;
    }else{
      return decodeResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken()async{
    return await storage.read(key: 'token') ?? '';
  }


}