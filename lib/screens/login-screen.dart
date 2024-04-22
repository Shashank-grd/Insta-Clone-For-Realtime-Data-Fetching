import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone/UI/inputfield.dart';
import 'package:insta_clone/firestorehelper/auth.dart';
import 'package:insta_clone/screens/signup-screen.dart';
import 'package:insta_clone/utils/color.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/utils/variables.dart';

import '../responsive/mobile.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen ({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController =TextEditingController();
  bool _isloading =false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen(),));
  }
  void loginUser() async{
    setState(() {
      _isloading = true;
    });
    String res= await AuthMethod().loginUser(email: _emailController.text, password: _passwordController.text);

   if(res=='success') {

     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Responsive_layout(webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout()),));

   }else{
     showSnackBar(res, context);
   }
    setState(() {
      _isloading = false;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width /3):
          const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(child: Container(),flex: 2,),

             SvgPicture.asset('assets/insta.svg',colorFilter: ColorFilter.mode(primaryColor,BlendMode.srcIn)  ,height: 64,),

              const SizedBox(height: 64,),

              TextFieldInput(textEditingController: _emailController, hintText: "Enter your Email", textInputType: TextInputType.emailAddress),

              const SizedBox(height: 24,),

              TextFieldInput(textEditingController: _passwordController, hintText: "Enter your password", textInputType: TextInputType.text,isPass: true,),

              const SizedBox(height: 24,),

              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isloading ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ) :const Text("Log in"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4)
                    )
                  ),
                    color: Colors.blue
                  ),
                ),
              ),

              const SizedBox(height: 24,),

              Flexible(child: Container(),flex: 2,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text( "Don't have an Account?"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8
                    ),
                  ),

                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text('Sign Up?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}