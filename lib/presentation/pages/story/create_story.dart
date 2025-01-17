import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instax/core/functions/date_reformats.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_multi_posts_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/functions/blur_hash.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/child_classes/post/story.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/story_cubit/story_cubit.dart';
import '../../cubit/user_info/user_info_cubit.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../register/widgets/popup_calling.dart';

class CreateStoryPage extends StatefulWidget {
  final SelectedImagesDetails storiesDetails;
  const CreateStoryPage({super.key, required this.storiesDetails});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  bool isItDone = true;
  late List<SelectedByte> selectedFiles;

  @override
  void initState() {
    selectedFiles = widget.storiesDetails.selectedFiles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.storiesDetails.multiSelectionMode
                  ? CustomMultiImagesDisplay(selectedImages: selectedFiles)
                  : Image.file(selectedFiles[0].selectedFile),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25.0))),
              child: listOfAddPost(),
            )
          ],
        ),
      ),
    );
  }

  Widget listOfAddPost() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconsAssets.minusIcon,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 40,
          ),
          Text(StringsManager.create.tr,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: Builder(builder: (builderContext) {
              UserInfoCubit userCubit =
                  BlocProvider.of<UserInfoCubit>(builderContext, listen: false);
              UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

              return Container(
                margin: const EdgeInsetsDirectional.all(3.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    return await createStory(personalInfo, userCubit);
                  },
                  isItDone: isItDone,
                  nameOfButton: StringsManager.share.tr,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> createStory(
      UserPersonalInfo personalInfo, UserInfoCubit userCubit) async {
    if (isItDone) {
      setState(() => isItDone = false);
      for (final storyDetails in selectedFiles) {
        Uint8List story = storyDetails.selectedByte;
        if (!storyDetails.isThatImage) {
          story = await createThumbnail(storyDetails.selectedFile) ?? story;
        }
        String blurHash = await CustomBlurHash.blurHashEncode(story);
        Story storyInfo =
            addStoryInfo(personalInfo, blurHash, storyDetails.isThatImage);
        if (!mounted) return;
        StoryCubit storyCubit = StoryCubit.get(context);
        await storyCubit.createStory(storyInfo, story);
        if (storyCubit.storyId != '') {
          userCubit.updateMyStories(storyId: storyCubit.storyId);
        }
        final SharedPreferences sharePrefs =
            await SharedPreferences.getInstance();
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() => isItDone = true));
        sharePrefs.remove(myPersonalId);
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => PopupCalling(myPersonalId)),
          (route) => false,
        );
      }
    }
  }

  Future<Uint8List?> createThumbnail(File selectedFile) async {
    final Uint8List? convertImage = await VideoThumbnail.thumbnailData(
      video: selectedFile.path,
      imageFormat: ImageFormat.PNG,
    );

    return convertImage;
  }

  Story addStoryInfo(
      UserPersonalInfo personalInfo, String blurHash, bool isThatImage) {
    return Story(
      publisherId: personalInfo.userId,
      datePublished: DateReformat.dateOfNow(),
      caption: "",
      comments: [],
      likes: [],
      blurHash: blurHash,
      isThatImage: isThatImage,
    );
  }
}
