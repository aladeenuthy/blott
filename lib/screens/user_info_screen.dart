import 'package:blott/utils/utils.dart';
import 'package:blott/viewmodels/user_info_view_model.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../utils/routes.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(builder: (context, vm, _) {
      return AppScaffold(
        isLoading: vm.isLoading,
        appBar: CustomAppBar(
          isLoading: vm.isLoading,
          centerTitle: false,
          title: const Text("Your legal name",
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              )),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              onChanged: () {
                vm.onchange(firstNameController.text.trim(),
                    lastNameController.text.trim());
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.heightSpace,
                    const Text(
                        "We need to know a bit about you so that we \ncan create your account.",
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        )),
                    24.heightSpace,
                    AppTextField(
                      controller: firstNameController,
                      hintText: "First name",
                    ),
                    24.heightSpace,
                    AppTextField(
                      controller: lastNameController,
                      hintText: "Last name",
                    ),
                  ]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: vm.buttonEnabled
              ? () async {
                  FocusScope.of(context).unfocus();
                  await vm.saveUserInfo(firstNameController.text.trim(),
                      lastNameController.text.trim());
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.notificationPermissionScreen);
                }
              : null,
          backgroundColor: vm.buttonEnabled
              ? AppColors.primary
              : AppColors.primary.withOpacity(.30),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    });
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key, required this.controller, required this.hintText});
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.inputFieldColor,
          fontSize: 20,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputFieldColor,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.inputFieldColor,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
