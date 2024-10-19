import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/entities/notification_check.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/custom_packages/snapping.dart';
import 'package:get/get.dart';
import '../../../../core/functions/date_reformats.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../data/models/child_classes/notification.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/notification_cubit/notification_cubit.dart';
import '../../../cubit/user_info/user_info_cubit.dart';
import '../../../cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';
import '../../../widgets/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../widgets/custom_widgets/custom_circulars_progress_indicators.dart';
import '../../../widgets/custom_widgets/custom_network_image_display.dart';
import '../../../widgets/custom_widgets/custom_smart_refresh.dart';
import '../../../widgets/popup_widgets/common/jump_arrow.dart';

class WelcomeCards extends StatefulWidget {
  final AsyncValueSetter<int>? onRefreshData;

  const WelcomeCards({super.key, this.onRefreshData});

  @override
  State<WelcomeCards> createState() => WelcomeCardsState();
}

class WelcomeCardsState extends State<WelcomeCards> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: isThatMobile
          ? CustomSmartRefresh(
              onRefreshData: widget.onRefreshData!, child: const _GetAllUsers())
          : const _GetAllUsers(),
    );
  }
}

class _GetAllUsers extends StatelessWidget {
  const _GetAllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _WelcomeTexts(),
        Flexible(
          child: BlocBuilder<UsersInfoInReelTimeBloc, UsersInfoInReelTimeState>(
            bloc: UsersInfoInReelTimeBloc.get(context)..add(LoadAllUsersInfo()),
            buildWhen: (previous, current) =>
                previous != current && (current is AllUsersInfoLoaded),
            builder: (context, state) {
              if (state is AllUsersInfoLoaded) {
                List<UserPersonalInfo> users = state.allUsersInfoInReelTime;
                if (users.isEmpty) {
                  return Center(
                    child: Text(
                      StringsManager.noUsers.tr,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    ),
                  );
                } else {
                  if (isThatMobile) {
                    return _PagesViewForMobile(users: users);
                  } else {
                    return _CardsForWeb(users: users);
                  }
                }
              } else {
                return const SizedBox();
                // return const ThineCircularProgress();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _PagesViewForMobile extends StatefulWidget {
  final List<UserPersonalInfo> users;

  const _PagesViewForMobile({Key? key, required this.users}) : super(key: key);

  @override
  State<_PagesViewForMobile> createState() => _PagesViewForMobileState();
}

class _PagesViewForMobileState extends State<_PagesViewForMobile> {
  int _selectedIndex = 0;
  PageController pageController = PageController(viewportFraction: 0.7);
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.users.length,
      controller: pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      itemBuilder: (context, index) {
        bool active = _selectedIndex == index;
        return _UserCardInfo(active: active, userInfo: widget.users[index]);
      },
    );
  }
}

class _CardsForWeb extends StatefulWidget {
  final List<UserPersonalInfo> users;

  const _CardsForWeb({Key? key, required this.users}) : super(key: key);
  @override
  State<_CardsForWeb> createState() => _CardsForWebState();
}

class _CardsForWebState extends State<_CardsForWeb> {
  int currentPage = 0;
  final ScrollController _scrollPageController = ScrollController();
  double initialPage = 0;
  @override
  void initState() {
    super.initState();
    initialPage = currentPage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthOfScreen = size.width;
    double heightOfStory = widthOfScreen < 900 ? 980 : 1500;
    double widthOfStory = widthOfScreen < 900 ? 340 : 520;

    return ScrollSnapList(
      itemBuilder: (_, index) {
        bool active = currentPage == index;

        return SizedBox(
          width: widthOfStory,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: heightOfStory,
                  width: widthOfStory,
                  child: _UserCardInfo(
                      active: active, userInfo: widget.users[index]),
                ),
                if (currentPage == index) ...[
                  if (index != 0)
                    _JumpArrow(
                      scrollPageController: _scrollPageController,
                      indexOfCurrentCard: index,
                      lengthOfCards: widget.users.length,
                      itemSize: widthOfStory,
                      onItemFocus: onItemFocus,
                    ),
                  if (index != widget.users.length - 1)
                    _JumpArrow(
                        scrollPageController: _scrollPageController,
                        indexOfCurrentCard: index,
                        lengthOfCards: widget.users.length,
                        itemSize: widthOfStory,
                        onItemFocus: onItemFocus,
                        isThatBack: false)
                ],
              ],
            ),
          ),
        );
      },
      onItemFocus: onItemFocus,
      itemSize: widthOfStory,
      listController: _scrollPageController,
      initialIndex: initialPage,
      dynamicItemSize: true,
      scrollDirection: Axis.horizontal,
      onReachEnd: () {
        if (kDebugMode) {
          print('Done!');
        }
      },
      itemCount: widget.users.length,
    );
  }

  void onItemFocus(pos) {
    setState(() => currentPage = pos);
    if (kDebugMode) {
      print('Done! $pos');
    }
  }
}

class _JumpArrow extends StatelessWidget {
  const _JumpArrow({
    Key? key,
    required ScrollController scrollPageController,
    this.isThatBack = true,
    required this.indexOfCurrentCard,
    required this.lengthOfCards,
    required this.itemSize,
    required this.onItemFocus,
  })  : _scrollPageController = scrollPageController,
        super(key: key);
  final int lengthOfCards;
  final int indexOfCurrentCard;
  final ScrollController _scrollPageController;
  final bool isThatBack;
  final double itemSize;
  final void Function(int) onItemFocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () async {
          if (isThatBack) {
            focusToItem(indexOfCurrentCard - 1);
          } else {
            focusToItem(indexOfCurrentCard + 1);
          }
        },
        child: SizedBox(child: ArrowJump(isThatBack: isThatBack)),
      ),
    );
  }

  double _calcCardLocation(int cardIndex) {
    if (cardIndex < 0) {
      cardIndex = 0;
    } else if (cardIndex > lengthOfCards - 1) {
      cardIndex = lengthOfCards - 1;
    }
    onItemFocus(cardIndex);
    return (cardIndex * itemSize);
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      _scrollPageController.animateTo(
        location,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void focusToItem(int index) {
    double targetLoc = _calcCardLocation(index);
    _animateScroll(targetLoc);
  }
}

class _WelcomeTexts extends StatelessWidget {
  const _WelcomeTexts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            StringsManager.welcomeToInstagram.tr,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            StringsManager.followPeopleToSee.tr,
            style: getNormalStyle(
                color: Theme.of(context).textTheme.headlineMedium!.color!,
                fontSize: 14),
          ),
        ),
        Center(
          child: Text(
            StringsManager.videosTheyShare.tr,
            style: getNormalStyle(
                color: Theme.of(context).textTheme.headlineMedium!.color!,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _UserCardInfo extends StatelessWidget {
  final UserPersonalInfo userInfo;

  final bool active;

  const _UserCardInfo({Key? key, required this.userInfo, required this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double margin = active ? 0 : 25;
    double width =
        MediaQuery.of(context).size.width - (isThatMobile ? 120 : 200);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: isThatMobile ? 330 : 400,
          width: width,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuint,
            margin: EdgeInsets.only(top: margin, bottom: margin),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).splashColor,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey.withOpacity(.15),
                    spreadRadius: 10,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ]),
            child: _BuildUserBrief(userInfo: userInfo),
          ),
        ),
      ),
    );
  }
}

class _BuildUserBrief extends StatelessWidget {
  const _BuildUserBrief({Key? key, required this.userInfo}) : super(key: key);
  final UserPersonalInfo userInfo;

  @override
  Widget build(BuildContext context) {
    List lastThreePostUrls = userInfo.lastThreePostUrls.length >= 3
        ? userInfo.lastThreePostUrls.sublist(0, 3)
        : userInfo.lastThreePostUrls;
    bool isIFollowHim = userInfo.followerPeople.contains(myPersonalId);
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatarOfProfileImage(
                userInfo: userInfo, bodyHeight: 900, showColorfulCircle: false),
            const SizedBox(height: 10),
            Text(
              userInfo.userName,
              style: getNormalStyle(color: Theme.of(context).focusColor),
            ),
            Text(
              userInfo.name,
              style: getNormalStyle(color: ColorManager.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (lastThreePostUrls.isEmpty) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        StringsManager.noPosts,
                        style:
                            getNormalStyle(color: Theme.of(context).focusColor),
                      ),
                    ),
                  ),
                ] else ...[
                  ...lastThreePostUrls.map(
                    (imageUrl) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 1),
                        child: SizedBox(
                            height:
                                isThatMobile ? 70 : (width > 900 ? 110 : 95),
                            width: isThatMobile ? 70 : (width > 900 ? 110 : 95),
                            child: NetworkDisplay(
                              url: imageUrl,
                              cachingWidth: isThatMobile ? 140 : 200,
                              cachingHeight: isThatMobile ? 140 : 200,
                            )),
                      );
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                UserPersonalInfo myPersonalInfo =
                    UserInfoCubit.getMyPersonalInfo(context);

                FollowUnFollowCubit followCubit =
                    FollowUnFollowCubit.get(context);
                if (isIFollowHim) {
                  await followCubit.unFollowThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);

                  myPersonalInfo.followedPeople.remove(userInfo.userId);
                  userInfo.followerPeople.remove(myPersonalId);

                  if (!context.mounted) return;
                  BlocProvider.of<NotificationCubit>(context)
                      .deleteNotification(
                          notificationCheck: createNotificationCheck(userInfo));
                } else {
                  await followCubit.followThisUser(
                      followingUserId: userInfo.userId,
                      myPersonalId: myPersonalId);

                  myPersonalInfo.followedPeople.add(userInfo.userId);
                  userInfo.followerPeople.add(myPersonalId);

                  if (!context.mounted) return;
                  BlocProvider.of<NotificationCubit>(context)
                      .createNotification(
                          newNotification:
                              createNotification(userInfo, myPersonalInfo));
                }
              },
              child: _FollowButton(isIFollowHim),
            ),
          ],
        ),
      ),
    );
  }

  NotificationCheck createNotificationCheck(UserPersonalInfo userInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      isThatLike: false,
      isThatPost: false,
    );
  }

  CustomNotification createNotification(
      UserPersonalInfo userInfo, UserPersonalInfo myPersonalInfo) {
    return CustomNotification(
      text: "started following you.",
      time: DateReformat.dateOfNow(),
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      isThatPost: false,
      senderName: myPersonalInfo.userName,
    );
  }
}

class _FollowButton extends StatelessWidget {
  final bool isIFollowHim;
  const _FollowButton(
    this.isIFollowHim, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:
            isIFollowHim ? Theme.of(context).primaryColor : ColorManager.blue,
        border: Border.all(
          color: isIFollowHim
              ? Theme.of(context).bottomAppBarTheme.color!
              : ColorManager.transparent,
          width: 0,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.grey.withOpacity(.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isIFollowHim
          ? Text(StringsManager.following.tr,
              style: getNormalStyle(color: Theme.of(context).focusColor))
          : Text(StringsManager.follow.tr,
              style: getNormalStyle(color: ColorManager.white)),
    );
  }
}
