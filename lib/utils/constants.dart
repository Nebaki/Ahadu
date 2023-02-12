import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

const PrimaryColor = Color.fromARGB(255, 21, 62, 95);
const String SETTING_BOX = 'settings';
const String API_BOX = 'api_data';
const String FAVORITE_BOX = 'favorite';

class ApiConstants {
  static String baseUrl = 'https://ahaduvacancy.com';
  static String usersEndpoint = '/jobs-list.json';
}


showCustomSnackBar(BuildContext context) => showTopSnackBar(
      context,
      const CustomSnackBar.error(
        message:
            "Something went wrong. Please check your Internet Connection and try again",
      ),
    );