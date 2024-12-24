import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:photoroomapp/shared/constants/app_colors.dart';
import 'package:photoroomapp/shared/constants/app_textstyle.dart';
import 'package:photoroomapp/shared/extensions/sized_box.dart';

import '../../../../../providers/in_app_purchase_provider.dart';

class PublicPrivateDialog extends ConsumerWidget {
  const PublicPrivateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final inAppPurchase = ref.watch(inAppPurchaseProvider);

    return Container(
      margin: const EdgeInsets.only(left: 50, right: 50, top: 265, bottom: 265),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Free Plan
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                color: AppColors.indigo,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Public",
                          style: AppTextstyle.interMedium(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "(Free plan)",
                          style: AppTextstyle.interMedium(
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    10.spaceY,
                    Text(
                      "Anyone can view your generations",
                      style: AppTextstyle.interMedium(
                        color: AppColors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Premium Plan
          Expanded(
            child: GestureDetector(
              onTap: () {
                // inAppPurchase.products.add(
                //   ProductDetails(
                //     id: "1",
                //     title: "premium",
                //     description: "premium",
                //     price: "1",
                //     rawPrice: 1,
                //     currencyCode: "usd"));
                // ref
                //     .read(inAppPurchaseProvider)
                //     .buyProduct(inAppPurchase.products.first);
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [AppColors.indigo, AppColors.pinkColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Private",
                            style: AppTextstyle.interMedium(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "(Premium)",
                            style: AppTextstyle.interMedium(
                              color: AppColors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      10.spaceY,
                      Text(
                        "Only you can see your generations",
                        style: AppTextstyle.interMedium(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                      10.spaceY,
                      // Handle products list
                      // if (inAppPurchase.products.isNotEmpty)
                      //   Text(
                      //     'Price: ${inAppPurchase.products.first.price}',
                      //     style: AppTextstyle.interMedium(
                      //       color: AppColors.white,
                      //       fontSize: 14,
                      //     ),
                      //   )
                      // else
                      //   Text(
                      //     'Loading price...',
                      //     style: AppTextstyle.interMedium(
                      //       color: AppColors.white,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
