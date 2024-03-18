import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize:  const Size.fromHeight(75),
      child: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   // Status bar brightness (optional)
        //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        //   statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        // ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 200,
              sigmaY: 200,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.white,
        title: const Center(
          child: Text(
            'DashFlix',
            style: TextStyle(

              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: GestureDetector(
          child: const Icon(
            CupertinoIcons.line_horizontal_3_decrease,

            weight: 900,
          ),
        ),
        forceMaterialTransparency: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              child: const Icon(
                CupertinoIcons.bell,

                weight: 900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
