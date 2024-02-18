import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vmblog/core/config/motion_toast.dart';
import 'package:vmblog/src/features/create_post/presentation/create_screen.dart';
import 'package:vmblog/src/features/home/presentation/HomeScreen.dart';
import 'package:vmblog/src/shared/utils/colors.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int active;
  const CustomBottomNavigation({required this.active, super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(onPressed: (){
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false, // Replace all routes
            );
          }, icon:  Icon(CupertinoIcons.heart_fill, color: active == 1?brown:grey.withOpacity(.4), size: 24,)),
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()),
            );
          }, icon:  Icon(CupertinoIcons.pencil_outline, color: active == 2?brown:grey.withOpacity(.4), size: 24,)),
        ],
      ),
    );
  }
}
