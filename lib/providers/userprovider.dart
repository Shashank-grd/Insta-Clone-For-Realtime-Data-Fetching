
import 'package:flutter/material.dart';
import 'package:insta_clone/Models/user.dart';
import 'package:insta_clone/firestorehelper/auth.dart';

class UserProvider with ChangeNotifier{
User? _user;
final AuthMethod _authMethod=AuthMethod();
User get getUser =>_user!;
Future<void> refreshUser() async{
  User user=await _authMethod.getUserDetails();
  _user=user;
  notifyListeners();
}
}