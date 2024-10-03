import 'package:blott/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/routes.dart';
import '../utils/utils.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(Assets.messagesIcon),
            24.heightSpace,
            const Text("Get the most out of Blott ✅",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  // height: 1.5,
                )),
            16.heightSpace,
            const Text(
                "Allow notifications to stay in the loop with \nyour payments, requests and groups.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16,
                )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  fixedSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  final bool isGranted =
                      await Utilities.requestNotificationPermision();
                  if (!context.mounted) return;
                  if (isGranted) {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.homeScreen);
                  }else{
                    Utilities.showErrorSnacbar(context, "Please allow notification permission in settings to continue");
                  }
                },
                child: const Text("Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            24.heightSpace,
          ],
        ),
      ),
    );
  }
}
