import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/core/utils/injector.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/presentation/cubit/auth_cubit/firebase_auth_cubit.dart';
import 'package:instax/presentation/pages/register/widgets/get_my_user_info.dart';
import 'package:instax/presentation/pages/register/widgets/register_widgets.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final SharedPreferences sharePrefs = injector<SharedPreferences>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isHeMovedToHome = false.obs;
  ValueNotifier<bool> isToastShowed = ValueNotifier(false);
  ValueNotifier<bool> isUserIdReady = ValueNotifier(true);
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);

  @override
  dispose() {
    super.dispose();
    isToastShowed.dispose();
    isUserIdReady.dispose();
    validateEmail.dispose();
    validatePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
        emailController: emailController,
        passwordController: passwordController,
        customTextButton: customTextButton(),
        validateEmail: validateEmail,
        validatePassword: validatePassword);
  }

  Widget customTextButton() {
    return blocBuilder();
  }

  Widget blocBuilder() {
    return ValueListenableBuilder(
      valueListenable: isToastShowed,
      builder: (context, bool isToastShowedValue, child) =>
          BlocListener<FirebaseAuthCubit, FirebaseAuthCubitState>(
        listenWhen: (prev, curr) => prev != curr,
        listener: (context, state) {
          if (state is CubitAuthConfirmed) {
            onAuthConfirmed(state);
          } else if (state is CubitAuthFailed && !isToastShowedValue) {
            isToastShowed.value = true;
            isUserIdReady.value = true;
            ToastMessage.toastStateError(state);
          }
        },
        child: loginButton(),
      ),
    );
  }

  onAuthConfirmed(CubitAuthConfirmed state) async {
    String userId = state.user.uid;
    isUserIdReady.value = true;
    myPersonalId = userId;
    if (myPersonalId.isNotEmpty) {
      await sharePrefs.setString("myPersonalId", myPersonalId);
      Get.offAll(() => GetMyPersonalInfo(myPersonalId: myPersonalId));
    } else {
      ToastMessage.toast(StringsManager.somethingWrong.tr);
    }
  }

  Widget loginButton() {
    FirebaseAuthCubit authCubit = FirebaseAuthCubit.get(context);

    return ValueListenableBuilder(
        valueListenable: isUserIdReady,
        builder: (context, bool isUserIdReadyValue, child) =>
            ValueListenableBuilder(
                valueListenable: validateEmail,
                builder: (context, bool validateEmailValue, child) =>
                    ValueListenableBuilder(
                        valueListenable: validatePassword,
                        builder: (context, bool validatePasswordValue, child) {
                          bool validate =
                              validatePasswordValue && validateEmailValue;

                          return CustomElevatedButton(
                            isItDone: isUserIdReadyValue,
                            nameOfButton: StringsManager.logIn.tr,
                            blueColor: validate,
                            onPressed: () async {
                              if (validate) {
                                isUserIdReady.value = false;
                                isToastShowed.value = false;

                                await authCubit.signIn(RegisteredUser(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim()));
                              }
                            },
                          );
                        })));
  }
}
