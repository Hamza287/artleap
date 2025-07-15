import 'package:Artleap.ai/shared/constants/app_assets.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';
import 'package:Artleap.ai/shared/extensions/sized_box.dart';
import 'package:flutter/material.dart';
import '../../../../../shared/constants/app_colors.dart';

class FilterOfTheDay extends StatelessWidget {
  const FilterOfTheDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Filters of Day',
              style: AppTextstyle.interMedium(
                fontSize: 18,
                color: AppColors.black,
              ),
            ),
          ),
          10.spaceY,
          Container(
            height: 289,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:const Color(0xFFE9EBF5) ,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        tileMode: TileMode.clamp,
                          radius: 2,
                          colors: [
                        Color(0xFFD4BEFF),
                        Color(0xFF683FEA),
                          ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Use now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              10.spaceX,
                              Icon(Icons.auto_awesome,color: Colors.white,size: 20,),
                            ],
                          ),
                          20.spaceX,
                          Image.asset(AppAssets.stackofcoins,width: 30,height: 30,),
                          Text(
                            "20",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}