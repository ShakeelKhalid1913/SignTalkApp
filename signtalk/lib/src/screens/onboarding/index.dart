import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:signtalk/src/utils/routes.dart';

import '../../constants/colors.dart';
import 'widgets/animated_btn.widget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          width: MediaQuery.of(context).size.width * 1.7,
          left: 100,
          bottom: 100,
          child: Image.asset(
            "assets/images/Spline.png",
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(),
          ),
        ),
        const RiveAnimation.asset(
          "assets/rive/shapes.riv",
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          ),
        ),
        AnimatedPositioned(
          top: isShowSignInDialog ? -50 : 0,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 260),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 260,
                    child: Column(
                      children: const [
                        Text(
                          "Sign Talk",
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: AppColors.kColor),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Learn the basics of sign language and start communicating with the world.",
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  AnimatedBtn(
                    btnAnimationController: _btnAnimationController,
                    press: () {
                      _btnAnimationController.isActive = true;

                      Future.delayed(
                        const Duration(milliseconds: 800),
                        () {
                          setState(() {
                            isShowSignInDialog = true;
                          });
                          //navigate to home screen
                          Navigator.pushNamed(context, Routes.homeScreen);
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 14,
                            ),
                            text: "By continuing, you agree to our ",
                            children: [
                          TextSpan(
                              text: 'Terms of Service and Privacy Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline))
                        ])),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
