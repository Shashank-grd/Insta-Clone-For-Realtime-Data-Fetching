import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone/screens/profile-screen.dart';
import 'package:insta_clone/utils/color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers= false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a User'),
          onFieldSubmitted: (String _) {
           setState(() {
             isShowUsers =true;
           });
          },
        ),
      ),
      body:isShowUsers?  FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
            .get(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index]['uid']))),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data!.docs[index]['photoUrl']),
                    ),
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                    ),
                  ),
                );
              });
        },
      ):
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child:const  Center(child: CircularProgressIndicator()),
                  );
                }
                return GridView.custom(
                  gridDelegate: SliverQuiltedGridDelegate(
                    crossAxisCount: 4, // Adjust as needed for desired columns
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    repeatPattern: QuiltedGridRepeatPattern.inverted,
                    pattern: [
                      QuiltedGridTile(2, 2), // Tile 1 (Double-sized width and height)
                      QuiltedGridTile(1, 1), // Tile 2 (Standard size)
                      QuiltedGridTile(1, 1), // Tile 3 (Standard size)
                      QuiltedGridTile(1, 2), // Tile 4 (Double-sized height)
                    ],
                  ),
                  childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.cover,
                    ),
                    childCount: (snapshot.data! as dynamic).docs.length,
                  ),
                );
              },
          ),
    );
  }
}
