
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Utilities {
  static String truncate(String stringToCut, int lengthToCutTo) {
    if (stringToCut.length > lengthToCutTo) {
      return "${stringToCut.substring(0, lengthToCutTo)}...";
    }
    return stringToCut;
  }

  static Future<bool> launchURL(
    String url,
  ) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }
  }

  static void showErrorSnacbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(message),
    ));
  }

  static Future<bool> requestNotificationPermision() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    } else {
      if (status.isPermanentlyDenied) {
        openAppSettings();
        return false;
      } else {
        status = await Permission.notification.request();
        if (status.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}
