import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';

import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/globale_variables.dart';

import '../resources/aut_methods.dart';
import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layoutscreen.dart';
import '../responsive/webScreenLayout.dart';
import '../utils/utils.dart';
import '../widgets/texte_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _paswordlController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _paswordlController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
      /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>HomeScreen()
            ),
                (route) => false);

*/

      setState(() {
        _isLoading = false;
      });
    } else {
      showSnackBar(context, res);
      /* setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }*/
    }
  }

  void navigatToSignUP() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : EdgeInsets.symmetric(
                      horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    'assets/images/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  TextFieldInput(
                    hintTexte: 'Enter your Email',
                    textEditingController: _emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintTexte: 'Enter your Password',
                    textEditingController: _paswordlController,
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  GestureDetector(
                    onTap: loginUser,
                    child: InkWell(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 25),
                              child: const Text('Log In'),
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  color: blueColor),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Don't have an account?"),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        onTap: navigatToSignUP,
                        child: Container(
                          child: Text(
                            " Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      )
                    ],
                  )
                  //buttonlogin
                  //transsition
                ],
              ))),
    );
  }
}
