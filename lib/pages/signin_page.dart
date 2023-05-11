import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/services/auth_service.dart';

import 'home_page.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static const String id = 'signin_page';

  @override
  State<SignInPage> createState() => _SignInpageState();
}

class _SignInpageState extends State<SignInPage> {

  var isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(email, password).then((value) => {
      _responseSignIn(value!),
    });
  }

  _responseSignIn(User firebaseUser){
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignUpPage() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(252, 175, 69, 1),
                  Color.fromRGBO(245, 96, 64, 1),
                ]
            )
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Instagram",
                          style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: "Billabong" ),),

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 17, color: Colors.white54)
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 17, color: Colors.white54)
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: _doSignIn,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.white60)
                            ),
                            child: const Center(
                              child: Text("Sign In",
                                style: TextStyle(color: Colors.white, fontSize: 17),),

                            ),
                          ),
                        )
                      ],
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: _callSignUpPage,
                      child: const Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                const SizedBox(height: 20,),
              ],
            ),
            isLoading? const Center(
              child: CircularProgressIndicator(),
            ): const SizedBox.shrink(),
          ],
        )
      ),
    );
  }
}
