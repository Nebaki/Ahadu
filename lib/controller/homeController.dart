import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../model/jobs.dart';
import '../service/dioService.dart';

class HomeController extends GetxController {
  RxList<JobsModel> jobs = RxList();
  RxBool isLoading = true.obs;
  RxBool isListViewScrollToTheDown = false.obs;
  RxBool isInternetConnect = true.obs;

  var url = "https://ahaduvacancy.com/jobs-list.json";

  /// For Chcecking Internet Conection
  isInternrtConnect() async {
    isInternetConnect.value = await InternetConnectionChecker().hasConnection;
  }

  /// Callin Api and getting data From server
  getJobs() async {
    isInternrtConnect();
    isLoading.value = true;
    var response = await DioService().getMethod(url);

    if (response.statusCode == 200) {
      response.data.forEach(
        (element) {
          print("refreshed-----------------------------------");
          jobs.add(JobsModel.fromJson(element));
          
        },
      );
      isLoading.value = false;
    }
  }

  

  

  @override
  void onInit() {
    getJobs();
    isInternrtConnect();
    super.onInit();
  }
}
