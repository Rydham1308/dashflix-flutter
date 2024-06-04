import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget getCarouselPage(String img, String ctype, String discount, bool isOddPage) {
  return Stack(
    children: [
      if (isOddPage)
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://image.tmdb.org/t/p/w500/$img',
              ),
              fit: BoxFit.cover,
            ),
          ),
        )
      else
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://image.tmdb.org/t/p/w500/$img',
              ),
              fit: BoxFit.cover,
            ),
          ),

        ),
      Container(
        margin: const EdgeInsets.only(right: 20, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.lightBlueAccent,
                    animationDuration: const Duration(milliseconds: 1000),
                    backgroundColor: Colors.black,
                    elevation: 20,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: const Size(69, 35),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Watch Now',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
