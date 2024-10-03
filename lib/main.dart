import 'package:blott/screens/news_screen.dart';
import 'package:blott/screens/notification_permission_screen.dart';
import 'package:blott/screens/splash_screen.dart';
import 'package:blott/screens/user_info_screen.dart';
import 'package:blott/utils/colors.dart';
import 'package:blott/utils/fonts.dart';
import 'package:blott/utils/routes.dart';
import 'package:blott/viewmodels/news_view_model.dart';
import 'package:blott/viewmodels/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoViewModel>(
          create: (_) => UserInfoViewModel(),
        ),
        ChangeNotifierProvider<NewsViewModel>(
          create: (_) => NewsViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Blott',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
         
          textTheme: ThemeData.light().textTheme.copyWith().apply(
                fontFamily: AppFonts.roboto,
                displayColor: AppColors.textColor,
                bodyColor: AppColors.textColor,
              ),
        ),
        home: const SplashScreen(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.homeScreen:
              return MaterialPageRoute(
                  builder: (context) => const NewsScreen());
            case AppRoutes.notificationPermissionScreen:
              return MaterialPageRoute(
                  builder: (context) => const NotificationPermissionScreen());
            case AppRoutes.userInfoScreen:
              return MaterialPageRoute(
                  builder: (context) => const UserInfoScreen());
            default:
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
          }
        },
      ),
    );
  }
}
