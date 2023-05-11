import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/utils_service.dart';
import 'home_page.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const String id = 'signup_page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();

  _doSignUp() async {
    String fullname = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();
    
    if(!email.contains(RegExp(
        r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'
    ))){
      return Utils.fireToast("Invalid email entered");
    }

    if(password.length < 8) {
      return Utils.fireToast("password must be at least 8 characters long");
    } else if(!password.contains(RegExp(r'[A-Z]'))) {
      return Utils.fireToast("Must contain at least one uppercase letter");
    } else if(!password.contains(RegExp(r'[a-z]'))) {
      return Utils.fireToast("Must contain at least one lowercase letter");
    } else if(!password.contains(RegExp(r'[0-9]'))) {
      return Utils.fireToast("There must be at least one number");
    } else if(!password.contains(RegExp(r'[!@#\$&*~]'))) {
      return Utils.fireToast("Must contain at least one character");
    }

    if (fullname.isEmpty || email.isEmpty || password.isEmpty) return;

    if (cpassword != password) {
      Utils.fireToast("Password and confirm password does not match");
      return;
    }
    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(fullname, email, password).then((value) => {
      _responseSignUp(value!),
    });
  }

  _responseSignUp(User firebaseUser){
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
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
                            controller: fullnameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Fullname",
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

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 50,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: TextField(
                            controller: cpasswordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 17, color: Colors.white54)
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: _doSignUp,
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white60),
                                borderRadius: BorderRadius.circular(7)
                            ),
                            child: const Center(
                              child: Text("Sign Up",
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
                    const Text("Already have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 16),),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: _callSignInPage,
                      child: const Text("Sign In",
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
