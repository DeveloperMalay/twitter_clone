import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/theme/pallete.dart';
import 'assets_constant.dart';

class UIConstant{
  static AppBar appBar(){
    return AppBar(
      title: SvgPicture.asset(AssetsConstants.twitterLogo,
      // ignore: deprecated_member_use
      color: Pallete.blueColor,
      height: 30,
      ),
    );
  }
}