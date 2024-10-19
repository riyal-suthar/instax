import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/core/resources/color_manager.dart';
import 'package:instax/presentation/cubit/auth_cubit/firebase_auth_cubit.dart';

import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../widgets/custom_widgets/custom_text_form_field.dart';
import '../sign_up_page.dart';
import 'or_text.dart';
import 'package:get/get.dart';

class RegisterWidgets extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final Widget customTextButton;
  final bool isThatSignIn;
  final ValueNotifier<bool> validateEmail;
  final ValueNotifier<bool> validatePassword;
  final ValueNotifier<bool>? rememberPassword;
  const RegisterWidgets(
      {super.key,
      required this.emailController,
      required this.passwordController,
      this.fullNameController,
      required this.customTextButton,
      this.isThatSignIn = true,
      required this.validateEmail,
      required this.validatePassword,
      this.rememberPassword});

  @override
  State<RegisterWidgets> createState() => _RegisterWidgetsState();
}

class _RegisterWidgetsState extends State<RegisterWidgets> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 50;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: isThatMobile
              ? buildColumn(context, height: height)
              : buildForWeb(context),
        ),
      )),
    );
  }

  SizedBox buildForWeb(BuildContext context) {
    return SizedBox(
      width: 352,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
                color: ColorManager.white,
                border: Border.all(color: ColorManager.grey, width: .2)),
            child: buildColumn(context),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
                color: ColorManager.white,
                border: Border.all(color: ColorManager.grey)),
            child: haveAccountRow(context),
          )
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, {double height = 400}) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!widget.isThatSignIn) const Spacer(),
          SvgPicture.asset(
            IconsAssets.instagramLogo,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 50,
          ),
          const SizedBox(
            height: 30,
          ),
          _EmailTextFormFields(
            hint: StringsManager.email.tr,
            controller: widget.emailController,
            validate: widget.validateEmail,
            isThatSignIn: widget.isThatSignIn,
          ),
          SizedBox(height: isThatMobile ? 15 : 6.5),
          if (!widget.isThatSignIn && widget.fullNameController != null) ...[
            CustomTextFormField(
              hint: StringsManager.fullName.tr,
              controller: widget.fullNameController!,
              isThatSignIn: widget.isThatSignIn,
            ),
            SizedBox(height: isThatMobile ? 15 : 6.5),
          ],
          CustomTextFormField(
            hint: StringsManager.password.tr,
            controller: widget.passwordController,
            isThatEmail: false,
            validate: widget.validatePassword,
            isThatSignIn: widget.isThatSignIn,
          ),
          if (!widget.isThatSignIn) ...[
            if (!isThatMobile) const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isThatMobile ? 4 : 0,
                    vertical: isThatMobile ? 15 : 0),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    ValueListenableBuilder(
                      valueListenable: widget.rememberPassword!,
                      builder: (context, bool rememberPasswordValue, child) =>
                          Checkbox(
                              value: rememberPasswordValue,
                              activeColor: isThatMobile
                                  ? ColorManager.white
                                  : ColorManager.blue,
                              fillColor: isThatMobile
                                  ? MaterialStateProperty.resolveWith(
                                      (Set states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.blue.withOpacity(.32);
                                      }
                                      return Colors.blue;
                                    })
                                  : null,
                              onChanged: (value) => widget.rememberPassword!
                                  .value = !rememberPasswordValue),
                    ),
                    Text(
                      StringsManager.rememberPassword.tr,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    )
                  ],
                ),
              ),
            ),
            if (!isThatMobile) const SizedBox(height: 10),
          ],
          widget.customTextButton,
          const SizedBox(height: 15),
          if (!widget.isThatSignIn) ...[
            const Spacer(),
            const Spacer(),
          ],
          if (isThatMobile) ...[
            const SizedBox(height: 8),
            if (!widget.isThatSignIn) ...[
              const Divider(color: ColorManager.lightGrey, height: 1),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15.0, right: 15.0, bottom: 6.5),
                child: haveAccountRow(context),
              ),
            ] else ...[
              haveAccountRow(context),
              const OrText(),
            ],
          ],
          if (widget.isThatSignIn) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                StringsManager.loginWithFacebook.tr,
                style: getNormalStyle(color: ColorManager.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Row haveAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isThatSignIn
              ? StringsManager.noAccount.tr
              : StringsManager.haveAccount.tr,
          style:
              getNormalStyle(fontSize: 13, color: Theme.of(context).focusColor),
        ),
        const SizedBox(width: 4),
        register(context),
      ],
    );
  }

  InkWell register(BuildContext context) {
    return InkWell(
        onTap: () {
          Get.to(const SignUpPage(),
              preventDuplicates: true,
              duration: const Duration(milliseconds: 0));
          if (widget.isThatSignIn) {
          } else {
            Get.back();
          }
        },
        child: registerText());
  }

  Text registerText() {
    return Text(
      widget.isThatSignIn ? StringsManager.signUp : StringsManager.logIn,
      style: getBoldStyle(fontSize: 13, color: ColorManager.blue),
    );
  }
}

class _EmailTextFormFields extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueNotifier<bool>? validate;
  final bool isThatSignIn;
  const _EmailTextFormFields(
      {super.key,
      required this.controller,
      required this.hint,
      this.validate,
      required this.isThatSignIn});

  @override
  State<_EmailTextFormFields> createState() => _EmailTextFormFieldsState();
}

class _EmailTextFormFieldsState extends State<_EmailTextFormFields> {
  String? errorMessage;

  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.text.toString().trim().isNotEmpty) {
        errorMessage = _validateEmail();
      } else {
        errorMessage = null;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: BlocConsumer<FirebaseAuthCubit, FirebaseAuthCubitState>(
          bloc: FirebaseAuthCubit.get(context)
            ..isThisEmailToken(email: widget.controller.text),
          listenWhen: (prev, curr) =>
              prev != curr && curr is CubitEmailVerificationLoaded,
          listener: (context, state) {
            if (!widget.isThatSignIn) {
              if (state is CubitEmailVerificationLoaded &&
                  state.isThisEmailToken) {
                errorMessage = "This email already exists.";
                widget.validate?.value = false;
              } else {
                errorMessage = null;
                widget.validate?.value = true;
              }
            }
          },
          buildWhen: (prev, curr) =>
              prev != curr && curr is CubitEmailVerificationLoaded,
          builder: (context, state) {
            return TextFormField(
              controller: widget.controller,
              cursorColor: ColorManager.teal,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 15),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: isThatMobile
                    ? getNormalStyle(color: Theme.of(context).indicatorColor)
                    : getNormalStyle(color: ColorManager.black54, fontSize: 12),
                fillColor: const Color.fromARGB(48, 232, 232, 232),
                filled: true,
                focusedBorder: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                errorStyle: getNormalStyle(color: ColorManager.red),
                errorText: isThatMobile ? errorMessage : null,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: isThatMobile ? 15 : 5),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _validateEmail() {
    if (!widget.controller.text.isNotEmpty) {
      setState(() => widget.validate!.value = false);
      return 'Please make sure your email address is valid';
    } else {
      setState(() => widget.validate!.value = true);
      return null;
    }
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: ColorManager.lightGrey, width: isThatMobile ? 1.0 : 0.8),
    );
  }
}
