import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/Models/post.dart';
import 'package:insta_clone/firestorehelper/storage-method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
 Future <String > uploadPost(
     String description,
     Uint8List file,
     String uid,
     String username,
     String profileImage
     ) async{
   String res="some error occcured";
   try{
     String photoUrl=await StorageMethods().uploadImageToStorage("posts",file,true);
     String postId=const Uuid().v1();
     Post post=Post(
         description: description,
         uid: uid,
         postId: postId,
         username: username,
         datePublished: DateTime.now(),
         postUrl: photoUrl,
         profileImage: profileImage,
         likes: []);

     _firestore.collection('posts').doc(postId).set(post.toJson(),);
     res="success";
   }catch(err){
     res=err.toString();
   }
   return res;
 }
 Future<void> likePost(String postId,String uid,List likes) async{
   try{
     if(likes.contains(uid)){
       await _firestore.collection('posts').doc(postId).update({
         'likes': FieldValue.arrayRemove([uid]),
       });
     }else{
      await _firestore.collection('posts').doc(postId).update({
         'likes': FieldValue.arrayUnion([uid]),
     });
     }
   }
   catch(e){
     print(e.toString(),);
   }
 }
  Future<void> postComment( String postID,String text,String uid,String name,String profilePic ) async{

   try{
     if(text.isNotEmpty){
       String commentId=const Uuid().v1();
      await _firestore.collection('posts').doc(postID).collection('comments').doc(commentId).set(
           {
             'profilePic': profilePic,
             'name': name,
             'uid': uid,
             'text': text,
             'commentId': commentId,
             'datePublished': DateTime.now(),
           }
       );
     }else{
       print('Text is Empty');
     }
   }catch(e){
     print(e.toString());
   }
  }

  //deleting post
Future<void> deletePost(String postId) async{
   try{

    await _firestore.collection('posts').doc(postId).delete();
   }catch(err){
     print(err.toString());
   }
}
//like comment
  Future<void> likeComments(String postId,String uid,List likes,String commentID) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentID).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }else{
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentID).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(e){
      print(e.toString(),);
    }
  }

  Future<void> followUser(String uid,String followId) async {

   try{
    DocumentSnapshot snap= await _firestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];

    if(following.contains(followId)){
      await _firestore.collection('users').doc(followId).update(
          {'followers': FieldValue.arrayRemove([uid])
          });

      await _firestore.collection('users').doc(uid).update(
          {'following': FieldValue.arrayRemove([followId])
          });
    }
    else{
      await _firestore.collection('users').doc(followId).update(
          {'followers': FieldValue.arrayUnion([uid])
          });

      await _firestore.collection('users').doc(uid).update(
          {'following': FieldValue.arrayUnion([followId])
          });
    }
   }catch(e){
     print(e.toString());
   }
  }
}