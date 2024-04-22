import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/feed-screen.dart';
import 'package:insta_clone/screens/post-screen.dart';
import 'package:insta_clone/screens/profile-screen.dart';
import 'package:insta_clone/screens/search-screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPost(),
  Text("noti"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
