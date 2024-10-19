import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/core/resources/styles_manager.dart';
import 'package:instax/core/utils/injector.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/presentation/cubit/auth_cubit/firebase_auth_cubit.dart';
import 'package:instax/presentation/cubit/user_info/add_new_user_cubit.dart';
import 'package:instax/presentation/cubit/user_info/search_about_user/search_about_user_bloc.dart';
import 'package:instax/presentation/pages/register/widgets/get_my_user_info.dart';
import 'package:instax/presentation/pages/register/widgets/register_widgets.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final bool validateControllers = false;
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);
  ValueNotifier<bool> rememberPassword = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      emailController: emailController,
      passwordController: passwordController,
      customTextButton: customTextButton(),
      validateEmail: validateEmail,
      validatePassword: validatePassword,
      fullNameController: fullNameController,
      isThatSignIn: false,
      rememberPassword: rememberPassword,
    );
  }

  Widget customTextButton() {
    return ValueListenableBuilder(
        valueListenable: rememberPassword,
        builder: (context, bool rememberPasswordValue, child) =>
            ValueListenableBuilder(
                valueListenable: validateEmail,
                builder: (context, bool validateEmailValue, child) =>
                    ValueListenableBuilder(
                        valueListenable: validatePassword,
                        builder: (context, bool validatePasswordValue, child) {
                          bool validate = validatePasswordValue &&
                              validateEmailValue &&
                              fullNameController.text.isNotEmpty;

                          return CustomElevatedButton(
                            isItDone: true,
                            isThatSignIn: true,
                            nameOfButton: StringsManager.next.tr,
                            blueColor: validate ? true : false,
                            onPressed: () async {
                              if (validate) {
                                Get.to(
                                    () => UserNamePage(
                                        emailController: emailController,
                                        passwordController: passwordController,
                                        fullNameController: fullNameController),
                                    duration: const Duration(seconds: 0));
                              }
                            },
                          );
                        })));
  }
}

class UserNamePage extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;
  const UserNamePage(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.fullNameController});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final userNameController = TextEditingController();

  bool isToastedShowed = false;
  bool validateEdits = false;
  bool isFieldEmpty = true;
  bool isHeMovedToHome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: isThatMobile
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: buildColumn(context),
              )
            : buildForWeb(context),
      )),
    );
  }

  Widget buildColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 100,
        ),
        Text(
          StringsManager.createUserName.tr,
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            StringsManager.addUserName.tr,
            style: getNormalStyle(color: ColorManager.grey, fontSize: 13),
          ),
        ),
        Text(
          StringsManager.youCanChangeUserNameLater.tr,
          style: getNormalStyle(color: ColorManager.grey, fontSize: 13),
        ),
        const SizedBox(height: 30),
        userNameTextField(context),
        customTextButton(),
      ],
    );
  }

  Widget buildForWeb(BuildContext context) {
    return SizedBox(
      width: 352,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: buildColumn(context),
          ),
        ],
      ),
    );
  }

  Widget userNameTextField(BuildContext context) {
    return BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
      bloc: BlocProvider.of<SearchAboutUserBloc>(context)
        ..add(FindSpecificUser(userNameController.text,
            searchForSingleLetter: true)),
      buildWhen: (prev, curr) => prev != curr && curr is SearchAboutUserLoaded,
      builder: (context, state) {
        List<UserPersonalInfo> usersWithSameUserName = [];

        if (state is SearchAboutUserLoaded) {
          usersWithSameUserName = state.users;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              validateEdits = usersWithSameUserName.isEmpty;
              if (userNameController.text.isEmpty) {
                validateEdits = false;
                isFieldEmpty = true;
              } else {
                isFieldEmpty = false;
              }
            }));

        return customTextField(context);
      },
    );
  }

  Padding customTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: TextFormField(
          controller: userNameController,
          cursorColor: ColorManager.teal,
          style:
              getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: StringsManager.username.tr,
            hintStyle: isThatMobile
                ? getNormalStyle(color: Theme.of(context).indicatorColor)
                : getNormalStyle(color: ColorManager.black54, fontSize: 12),
            fillColor: const Color.fromARGB(48, 232, 232, 232),
            filled: true,
            focusedBorder: outlineInputBorder(),
            suffixIcon: isFieldEmpty
                ? null
                : validateEdits
                    ? rightIcon()
                    : wrongIcon(),
            enabledBorder: outlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: isThatMobile ? 15 : 5),
            errorText: (isFieldEmpty || validateEdits)
                ? null
                : (isThatMobile ? StringsManager.thisUserNameExist.tr : null),
            errorStyle: getNormalStyle(color: ColorManager.red),
          ),
          onChanged: (value) {
            SearchAboutUserBloc.get(context).add(FindSpecificUser(
                userNameController.text,
                searchForSingleLetter: true));
          },
        ),
      ),
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_rounded, color: ColorManager.green, size: 27);
  }

  Widget wrongIcon() {
    return const Icon(
      Icons.close_rounded,
      color: ColorManager.red,
      size: 27,
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: ColorManager.lightGrey, width: isThatMobile ? 1.0 : 0.8),
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      AddNewUserCubit userCubit = AddNewUserCubit.get(context);

      return BlocConsumer<FirebaseAuthCubit, FirebaseAuthCubitState>(
        listenWhen: (prev, curr) => prev != curr,
        listener: (context, state) {
          if (state is CubitAuthConfirmed) {
            addNewUser(state, userCubit);
            moveToMain(state);
          } else if (state is CubitAuthFailed && !isToastedShowed) {
            ToastMessage.toastStateError(state);
          }
        },
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, authState) {
          return CustomElevatedButton(
            isItDone: authState is! CubitAuthConfirming,
            nameOfButton: StringsManager.signUp.tr,
            blueColor: validateEdits,
            onPressed: () async {
              FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);
              if (validateEdits) {
                setState(() {
                  isToastedShowed = false;
                });

                await authCubit.signUp(RegisteredUser(
                    email: widget.emailController.text,
                    password: widget.passwordController.text));
              }
            },
          );
        },
      );
    });
  }

  moveToMain(CubitAuthConfirmed authState) async {
    myPersonalId = authState.user.uid;

    final SharedPreferences sharedPrefs = injector<SharedPreferences>();
    if (!isHeMovedToHome) {
      setState(() {
        isHeMovedToHome = true;
      });
    }

    if (myPersonalId.isNotEmpty) {
      await sharedPrefs.setString("myPersonalId", myPersonalId);
      Get.offAll(() => GetMyPersonalInfo(myPersonalId: myPersonalId));
    } else {
      ToastMessage.toast(StringsManager.somethingWrong.tr);
    }
  }

  addNewUser(CubitAuthConfirmed authState, AddNewUserCubit userCubit) {
    String fullName = widget.fullNameController.text.toString().trim();
    List<dynamic> charactersOfName = [];
    String nameOfLower = fullName.toLowerCase();

    for (int i = 0; i < nameOfLower.length; i++) {
      charactersOfName = charactersOfName + [nameOfLower.substring(0, i + 1)];
    }

    String userName = userNameController.text;
    UserPersonalInfo newUserInfo = UserPersonalInfo(
      name: fullName,
      email: authState.user.email!,
      userName: userName,
      bio: "",
      bioLinks: [],
      profileImageUrl: "",
      userId: authState.user.uid,
      followedPeople: const [],
      followerPeople: const [],
      posts: const [],
      chatsOfGroups: const [],
      stories: const [],
      charactersOfName: charactersOfName,
      lastThreePostUrls: const [],
    );
    userCubit.addNewUser(newUserInfo);
  }
}
