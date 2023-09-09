import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/aut_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';

import '../responsive/mobileScreenLayout.dart';
import '../responsive/responsive_layoutscreen.dart';
import '../responsive/webScreenLayout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/texte_field_input.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _paswordlController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _paswordlController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void navigatToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _paswordlController.text,
        username: _userNameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
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
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://imgs.search.brave.com/MWlI8P3aJROiUDO9A-LqFyca9kSRIxOtCg_Vf1xd9BA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzE1Lzg0LzQz/LzM2MF9GXzIxNTg0/NDMyNV90dFg5WWlJ/SXllYVI3TmU2RWFM/TGpNQW15NEd2UEM2/OS5qcGc'),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
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
                    hintTexte: 'Enter your Name',
                    textEditingController: _userNameController,
                    textInputType: TextInputType.text,
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
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    hintTexte: 'Enter your bio',
                    textEditingController: _bioController,
                    textInputType: TextInputType.text,
                  ),
                  GestureDetector(
                    onTap: signUpUser,
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text('Sign Up'),
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
                        child: Text(" have an account?"),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      GestureDetector(
                        onTap: navigatToLogin,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            " login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
