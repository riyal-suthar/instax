import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/presentation/pages/time_line/all_user_timeline/search_about_user.dart';
import 'package:instax/presentation/pages/time_line/widgets/all_timeline_gridview.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../data/models/child_classes/post/post.dart';
import '../../../cubit/postInfo_cubit/post_cubit.dart';
import 'package:get/get.dart';

class AllUsersTimeLinePage extends StatelessWidget {
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);
  final ValueNotifier<bool> isThatEndOfList = ValueNotifier(false);
  final ValueNotifier<bool> reloadData = ValueNotifier(true);

  AllUsersTimeLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    rebuildUsersInfo.value = false;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: isThatMobile ? searchAppBar(context) : null,
        body: blocBuilder(),
      ),
    );
  }

  AppBar searchAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextField(
            onTap: () {
              Go(context).push(page: const SearchAboutUserPage());
            },
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsetsDirectional.all(2.0),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Theme.of(context).focusColor),
                hintText: StringsManager.search,
                hintStyle: Theme.of(context).textTheme.displayLarge,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Future<void> getData(BuildContext context, int index) async {
    await BlocProvider.of<PostCubit>(context).getAllPostsInfo();
    rebuildUsersInfo.value = true;
    reloadData.value = true;
  }

  ValueListenableBuilder<bool> blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool value, child) =>
          BlocBuilder<PostCubit, PostState>(
        bloc: BlocProvider.of<PostCubit>(context)..getAllPostsInfo(),
        buildWhen: (previous, current) {
          if (previous != current &&
              (current is AllPostsLoaded || current is PostFailed)) {
            return true;
          }

          if (value && current is AllPostsLoaded) {
            rebuildUsersInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (BuildContext context, state) {
          if (state is AllPostsLoaded) {
            List<Post> imagePosts = [];
            List<Post> videoPosts = [];

            for (Post element in state.allPostsInfo) {
              bool isThatImage = element.isThatMix || element.isThatImage;
              isThatImage ? imagePosts.add(element) : videoPosts.add(element);
            }

            return AllTimeLineGridView(
              onRefreshData: (int index) => getData(context, index),
              postsImagesInfo: imagePosts,
              postsVideosInfo: videoPosts,
              isThatEndOfList: isThatEndOfList,
              reloadData: reloadData,
              allPostsInfo: state.allPostsInfo,
            );
          } else if (state is PostFailed) {
            ToastMessage.toastStateError(state);
            return Center(
                child: Text(
              StringsManager.somethingWrong.tr,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 18),
            ));
          } else {
            return loadingWidget(context);
          }
        },
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Center(
      child: SizedBox(
        width: isThatMobile ? null : 910,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).textTheme.headlineSmall!.color!,
          highlightColor: Theme.of(context).textTheme.titleLarge!.color!,
          child: StaggeredGridView.countBuilder(
            crossAxisSpacing: isThatMobile ? 1.5 : 30,
            mainAxisSpacing: isThatMobile ? 1.5 : 30,
            crossAxisCount: 3,
            itemCount: 16,
            itemBuilder: (_, __) {
              return Container(
                  color: ColorManager.lightDarkGray, width: double.infinity);
            },
            staggeredTileBuilder: (index) {
              double num = (index == (isThatMobile ? 2 : 1) ||
                      (index % 11 == 0 && index != 0))
                  ? 2
                  : 1;
              return StaggeredTile.count(isThatMobile ? 1 : num.toInt(), num);
            },
          ),
        ),
      ),
    );
  }
}
