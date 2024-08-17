import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photoroomapp/presentation/views/home_section/favourites_screen/favourites_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/home_screen/home_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/profile_screen/profile_screen.dart';
import 'package:photoroomapp/presentation/views/home_section/prompt_or_ref_screen/promp_or_ref_screen.dart';
import 'package:photoroomapp/shared/shared.dart';

class BottomNavBar extends StatefulWidget {
  static const String routeName = 'homescreen';
  BottomNavBar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  // final List<Color> colors = [
  //   Colors.yellow,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  // ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 4, vsync: this);
    tabController.animation!.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Color unselectedColor = colors[currentPage].computeLuminance() < 0.4
    //     ? Colors.black
    //     : Colors.white;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.purple,
          leading: const SizedBox(),
          title: Text(
            "Imaginary Verse",
            style: AppTextstyle.interBold(color: AppColors.white, fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: AppColors.mediumIndigo, shape: BoxShape.circle),
                child: Icon(
                  Icons.notifications_none,
                  size: 21,
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: BottomBar(
          fit: StackFit.expand,
          borderRadius: BorderRadius.circular(500),
          duration: Duration(seconds: 1),
          showIcon: false,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: AppColors.purple.withOpacity(0.6),
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 35,
          iconWidth: 35,
          reverse: false,
          hideOnScroll: false,
          scrollOpposite: false,
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: const [
              HomeScreen(),
              PrompOrReferenceScreen(),
              FavouritesScreen(),
              ProfileScreen()
            ],
          ),
          child: TabBar(
            indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            controller: tabController,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            tabs: [
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.home,
                  color:
                      currentPage == 0 ? AppColors.white : AppColors.lightgrey,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.add,
                  color:
                      currentPage == 1 ? AppColors.white : AppColors.lightgrey,
                )),
              ),
              SizedBox(
                height: 55,
                width: 40,
                child: Center(
                    child: Icon(
                  Icons.favorite,
                  color:
                      currentPage == 2 ? AppColors.white : AppColors.lightgrey,
                )),
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
