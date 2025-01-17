import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_gallery_display.dart';
import '../../core/resources/assets_manager.dart';
import '../../core/resources/color_manager.dart';
import '../../core/utils/injector.dart';
import '../cubit/postInfo_cubit/post_cubit.dart';
import '../pages/profile/personal_profile_page.dart';
import '../pages/time_line/all_user_timeline/all_user_time_line.dart';
import '../pages/time_line/my_own_timeline/home-page.dart';
import '../pages/video/videos_page.dart';
import '../widgets/personalImage_icon.dart';

class MobileScreenLayout extends StatefulWidget {
  final String userId;
  const MobileScreenLayout(this.userId, {Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  ValueNotifier<bool> playHomeVideo = ValueNotifier(false);
  ValueNotifier<bool> playMainReelVideos = ValueNotifier(false);
  CupertinoTabController controller = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: playMainReelVideos,
      builder: (BuildContext context, bool value, __) {
        return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
                backgroundColor:
                    value ? ColorManager.black : Theme.of(context).primaryColor,
                height: 45,
                border: Border.all(color: ColorManager.transparent),
                items: [
                  navigationBarItem(IconsAssets.home, value),
                  navigationBarItem(IconsAssets.search, value),
                  navigationBarItem(IconsAssets.plus, value),
                  navigationBarItem(IconsAssets.video, value, smallIcon: true),
                  personalImageItem(),
                ]),
            controller: controller,
            tabBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                playMainReelVideos.value = controller.index == 3 ? true : false;
                playHomeVideo.value = controller.index == 0 ? true : false;
              });

              switch (index) {
                case 0:
                  return homePage();
                case 1:
                  return allUsersTimLinePage();
                case 2:
                  return postPage();
                case 3:
                  return videoPage(value);
                default:
                  return personalProfilePage();
              }
            });
      },
    );
  }

  CupertinoTabView allUsersTimLinePage() => CupertinoTabView(
        builder: (context) =>
            CupertinoPageScaffold(child: AllUsersTimeLinePage()),
      );

  CupertinoTabView postPage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: Container(),
        ),
      );

  CupertinoTabView personalProfilePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
          child: BlocProvider<PostCubit>(
            create: (context) => injector<PostCubit>(),
            child: PersonalProfilePage(personalId: widget.userId),
          ),
        ),
      );

  Widget videoPage(bool value) => CupertinoTabView(
      builder: (context) => CupertinoPageScaffold(
            child: BlocProvider<PostCubit>(
              create: (context) => injector<PostCubit>(),
              child: VideosPage(stopVideo: playMainReelVideos),
            ),
          ));

  Widget homePage() => CupertinoTabView(
        builder: (context) => CupertinoPageScaffold(
            child: BlocProvider<PostCubit>(
          create: (context) => injector<PostCubit>(),
          child: ValueListenableBuilder(
            valueListenable: playHomeVideo,
            builder: (context, bool playVideoValue, child) => HomePage(
              userId: widget.userId,
              playVideo: playVideoValue,
            ),
          ),
        )),
      );

  BottomNavigationBarItem personalImageItem() =>
      const BottomNavigationBarItem(icon: PersonalImageIcon());

  BottomNavigationBarItem navigationBarItem(String icon, bool value,
      {bool smallIcon = false}) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        height: smallIcon ? 23 : 25,
        colorFilter: ColorFilter.mode(
            value ? ColorManager.white : Theme.of(context).focusColor,
            BlendMode.srcIn),
      ),
    );
  }
}
