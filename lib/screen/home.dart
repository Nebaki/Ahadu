import 'dart:async';
import 'package:ahadu/utils/constants.dart';
import 'package:ahadu/screen/jobDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocsy_esys_flutter_share/vocsy_esys_flutter_share.dart';
import '../controller/homeController.dart';
import 'ads.dart';

enum _menuItem { open, favorite, share }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  HomeController homeController = Get.put(HomeController());

  final favoriteBox = Hive.box(FAVORITE_BOX);
  Future<void> favoriteItem(Map<String, dynamic> newFav) async {
    await favoriteBox.add(newFav);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Saved as favorite')));
  }

  bool isLast = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Ahadu vacancy",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: Obx(
        () => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: homeController.isInternetConnect.value
              ? homeController.isLoading.value
                  ? getShimmerLoading()
                  : _buildMainBody()
              : _buildNoInternetConnection(context),
        ),
      ),
    );
  }

  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, _) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        height: 18.0,
                        color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40),
                        width: 5,
                        height: 15.0,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 80,
                                height: 18.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 80,
                                height: 18.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 80,
                                height: 18.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            height: 20,
                            width: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 150,
                            height: 18.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }

  /// Main Body
  RefreshIndicator _buildMainBody() {
    return RefreshIndicator(
      onRefresh: () async {
        await homeController.jobs();
      },
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: homeController.jobs.length,
          itemBuilder: (context, index) {
              homeController.jobs.length < index
                  ? SetState(){} isLast = false
                  : isLast = true;
            if (index > 0 && index % 5 == 0) {
              return Column(
                children: [
                  BottomBannerAd(),
                  InkWell(
                    onTap: () {
                      Get.to(() => JobDetail(), arguments: [
                        {
                          'id': homeController.jobs[index].id.toString(),
                          "name":
                              homeController.jobs[index].companyName.toString(),
                          "Description": homeController
                              .jobs[index].jobDescription
                              .toString(),
                          "logo":
                              homeController.jobs[index].companyLogo.toString(),
                          "location":
                              homeController.jobs[index].location.toString(),
                          "type":
                              homeController.jobs[index].workType.toString(),
                          "deadline":
                              homeController.jobs[index].jobDeadline.toString(),
                          "jobTitle":
                              homeController.jobs[index].jobTitle.toString(),
                          "level": homeController.jobs[index].level.toString(),
                          "salary":
                              homeController.jobs[index].salary.toString(),
                        }
                      ]);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      radius: 20.0,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://ahaduvacancy.com/Uploads/Images/" +
                                                homeController
                                                    .jobs[index].companyLogo
                                                    .toString(),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.red,
                                        highlightColor: Colors.yellow,
                                        child: Text(
                                            homeController.jobs[index].jobTitle
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton<_menuItem>(
                                    onSelected: (value) {
                                      switch (value) {
                                        case _menuItem.open:
                                          Get.to(() => JobDetail(), arguments: [
                                            {
                                              "salary": homeController
                                                  .jobs[index].salary
                                                  .toString(),
                                              "name": homeController
                                                  .jobs[index].companyName
                                                  .toString(),
                                              "Description": homeController
                                                  .jobs[index].jobDescription
                                                  .toString(),
                                              "logo": homeController
                                                  .jobs[index].companyLogo
                                                  .toString(),
                                              "location": homeController
                                                  .jobs[index].location
                                                  .toString(),
                                              "id": homeController
                                                  .jobs[index].id
                                                  .toString(),
                                              "type": homeController
                                                  .jobs[index].workType
                                                  .toString(),
                                              "deadline": homeController
                                                  .jobs[index].jobDeadline
                                                  .toString(),
                                              "jobTitle": homeController
                                                  .jobs[index].jobTitle
                                                  .toString(),
                                              'level': homeController
                                                  .jobs[index].level
                                                  .toString(),
                                            }
                                          ]);
                                          break;
                                        case _menuItem.favorite:
                                          favoriteItem({
                                            "salary": homeController
                                                .jobs[index].salary
                                                .toString(),
                                            "name": homeController
                                                .jobs[index].companyName
                                                .toString(),
                                            "Description": homeController
                                                .jobs[index].jobDescription
                                                .toString(),
                                            "logo": homeController
                                                .jobs[index].companyLogo
                                                .toString(),
                                            "location": homeController
                                                .jobs[index].location
                                                .toString(),
                                            "id": homeController.jobs[index].id
                                                .toString(),
                                            "type": homeController
                                                .jobs[index].workType
                                                .toString(),
                                            "deadline": homeController
                                                .jobs[index].jobDeadline
                                                .toString(),
                                            "jobTitle": homeController
                                                .jobs[index].jobTitle
                                                .toString(),
                                            'level': homeController
                                                .jobs[index].level
                                                .toString(),
                                          });
                                          break;
                                        case _menuItem.share:
                                          try {
                                            VocsyShare.text(
                                                'Ahadu vacancy',
                                                'https://ahaduvacancy.com/vacancy-detail.php?id=${homeController.jobs[index].id.toString()}',
                                                'text/plain');
                                          } catch (e) {
                                            print('error: $e');
                                          }
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: _menuItem.open,
                                        child: Text('Open',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: PrimaryColor)),
                                      ),
                                      PopupMenuItem(
                                          value: _menuItem.favorite,
                                          child: Text('Favorite',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                  color: PrimaryColor))),
                                      PopupMenuItem(
                                          value: _menuItem.share,
                                          child: Text("Share",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: PrimaryColor,
                                                  fontFamily: 'Poppins'))),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.location_city),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  homeController
                                                      .jobs[index].companyName
                                                      .toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.location_on_outlined),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  homeController
                                                      .jobs[index].location
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.work_outline),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  homeController
                                                      .jobs[index].workType
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.lock_clock),
                                      Text(
                                        homeController.jobs[index].jobDeadline
                                            .toString(),
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  isLast
                      ? Container(
                          child: Text('no item'),
                        )
                      : Container()
                ],
              );
            } else {
              return InkWell(
                onTap: () {
                  Get.to(() => JobDetail(), arguments: [
                    {
                      'id': homeController.jobs[index].id.toString(),
                      "name": homeController.jobs[index].companyName.toString(),
                      "Description":
                          homeController.jobs[index].jobDescription.toString(),
                      "logo": homeController.jobs[index].companyLogo.toString(),
                      "location":
                          homeController.jobs[index].location.toString(),
                      "type": homeController.jobs[index].workType.toString(),
                      "deadline":
                          homeController.jobs[index].jobDeadline.toString(),
                      "jobTitle":
                          homeController.jobs[index].jobTitle.toString(),
                      "level": homeController.jobs[index].level.toString(),
                      "salary": homeController.jobs[index].salary.toString(),
                    }
                  ]);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                  radius: 20.0,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://ahaduvacancy.com/Uploads/Images/" +
                                            homeController
                                                .jobs[index].companyLogo
                                                .toString(),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.red,
                                    highlightColor: Colors.yellow,
                                    child: Text(
                                        homeController.jobs[index].jobTitle
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              PopupMenuButton<_menuItem>(
                                onSelected: (value) {
                                  switch (value) {
                                    case _menuItem.open:
                                      Get.to(() => JobDetail(), arguments: [
                                        {
                                          "salary": homeController
                                              .jobs[index].salary
                                              .toString(),
                                          "name": homeController
                                              .jobs[index].companyName
                                              .toString(),
                                          "Description": homeController
                                              .jobs[index].jobDescription
                                              .toString(),
                                          "logo": homeController
                                              .jobs[index].companyLogo
                                              .toString(),
                                          "location": homeController
                                              .jobs[index].location
                                              .toString(),
                                          "id": homeController.jobs[index].id
                                              .toString(),
                                          "type": homeController
                                              .jobs[index].workType
                                              .toString(),
                                          "deadline": homeController
                                              .jobs[index].jobDeadline
                                              .toString(),
                                          "jobTitle": homeController
                                              .jobs[index].jobTitle
                                              .toString(),
                                          'level': homeController
                                              .jobs[index].level
                                              .toString(),
                                        }
                                      ]);
                                      break;
                                    case _menuItem.favorite:
                                      favoriteItem({
                                        "salary": homeController
                                            .jobs[index].salary
                                            .toString(),
                                        "name": homeController
                                            .jobs[index].companyName
                                            .toString(),
                                        "Description": homeController
                                            .jobs[index].jobDescription
                                            .toString(),
                                        "logo": homeController
                                            .jobs[index].companyLogo
                                            .toString(),
                                        "location": homeController
                                            .jobs[index].location
                                            .toString(),
                                        "id": homeController.jobs[index].id
                                            .toString(),
                                        "type": homeController
                                            .jobs[index].workType
                                            .toString(),
                                        "deadline": homeController
                                            .jobs[index].jobDeadline
                                            .toString(),
                                        "jobTitle": homeController
                                            .jobs[index].jobTitle
                                            .toString(),
                                        'level': homeController
                                            .jobs[index].level
                                            .toString(),
                                      });
                                      break;
                                    case _menuItem.share:
                                      try {
                                        VocsyShare.text(
                                            'Ahadu vacancy',
                                            'https://ahaduvacancy.com/vacancy-detail.php?id=${homeController.jobs[index].id.toString()}',
                                            'text/plain');
                                      } catch (e) {
                                        print('error: $e');
                                      }
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: _menuItem.open,
                                    child: Text('Open',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor)),
                                  ),
                                  PopupMenuItem(
                                      value: _menuItem.favorite,
                                      child: Text('Favorite',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                              color: PrimaryColor))),
                                  PopupMenuItem(
                                      value: _menuItem.share,
                                      child: Text("Share",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: PrimaryColor,
                                              fontFamily: 'Poppins'))),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 200,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              homeController
                                                  .jobs[index].companyName
                                                  .toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.location_on_outlined),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              homeController
                                                  .jobs[index].location
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.work_outline),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              homeController
                                                  .jobs[index].workType
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Poppins'),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.lock_clock),
                                  Text(
                                    homeController.jobs[index].jobDeadline
                                        .toString(),
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  /// Loading Widget
  Center _buildLoading() {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset(
          'assets/lotties/a.json',
        ),
      ),
    );
  }

  /// When Internet is't Okay, show thsi widget
  Center _buildNoInternetConnection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
            child: Lottie.asset('assets/lotties/no_internet_lottie.json'),
          ),
          MaterialButton(
            onPressed: () => _materialOnTapButton(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: PrimaryColor,
            child: const Text(
              "Try Again",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  /// onTap Func of "Try Again Button"
  void _materialOnTapButton(BuildContext context) async {
    if (await InternetConnectionChecker().hasConnection == true) {
      homeController.getJobs();
    } else {
      showCustomSnackBar(context);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
