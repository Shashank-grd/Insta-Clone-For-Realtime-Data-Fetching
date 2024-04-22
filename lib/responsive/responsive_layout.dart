import 'package:flutter/material.dart';
import 'package:insta_clone/providers/userprovider.dart';
import 'package:insta_clone/utils/variables.dart';
import 'package:provider/provider.dart';

class Responsive_layout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const Responsive_layout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout
  }) : super (key: key);

  @override
  State<Responsive_layout> createState() => _ResponsiveLayoutState();
}
class _ResponsiveLayoutState extends State<Responsive_layout>{

  @override
  void initState(){
    super.initState();
     addData();
  }

  addData() async{
    UserProvider _userProvider = Provider.of(context,listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
        builder: (context,constraints){
          if (constraints.maxWidth > webScreenSize){
            return widget.webScreenLayout;
          }
          return widget.mobileScreenLayout;
        }
    );
  }
}