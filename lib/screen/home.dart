import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:async';
import 'package:ahadu/constants.dart';
import 'package:ahadu/model/jobs.dart';
import 'package:ahadu/screen/jobDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vocsy_esys_flutter_share/vocsy_esys_flutter_share.dart';
import 'package:ahadu/noInternet.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'bottomAd.dart';
import 'package:flutter_offline/flutter_offline.dart';

enum _menuItem { open, favorite, share }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List posts = [];
  int page = 1;
  final int _maxlength = 20;
  bool isLoadingMore = false;
  bool hasMore = true;
  late Future<List<Jobs>> _future;

  bool isPerformingRequest = false;
  int pageNumber = 0;

  Future<List<Jobs>> job() async {
    var url = Uri.parse("https://ahaduvacancy.com/jobs-list.json?page=${page}");

    try {
      var response = await http.get(url);

      setState(() {
        posts = (json.decode(response.body) as List)
            .map((e) => Jobs.fromJson(e))
            .toList();
      });
      return _processResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }

  Future<void> refresh() async {
    final client = RetryClient(http.Client());
    try {
      print(await client.read(
          Uri.http('https://ahaduvacancy.com/jobs-list.json?page=${page}')));
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    _future = job();
    scrollController.addListener(_scrolListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  bool isLoaded = false;
  final scrollController = ScrollController();
  var limit = 15;
  final favoriteBox = Hive.box(FAVORITE_BOX);
  Future<void> favoriteItem(Map<String, dynamic> newFav) async {
    await favoriteBox.add(newFav);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Saved as favorite')));
  }

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
        body: OfflineBuilder(
            debounceDuration: Duration.zero,
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Center(
                    child: Text('Please check your internet connection!'));
              }
              return child;
            },
            child: RefreshIndicator(
              onRefresh: _pullRefresh,
              child: FutureBuilder<List<Jobs>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Jobs> active = snapshot.data as List<Jobs>;
                    return SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          controller: scrollController,
                          itemCount: posts.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == posts.length) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (index > 0 && index % 5 == 0) {
                              return Column(
                                children: [
                                  BottomBannerAd(),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => JobDetail(), arguments: [
                                        {
                                          'id': active[index].id.toString(),
                                          "name": active[index]
                                              .companyName
                                              .toString(),
                                          "Description": active[index]
                                              .jobDescription
                                              .toString(),
                                          "logo": active[index]
                                              .companyLogo
                                              .toString(),
                                          "location":
                                              active[index].location.toString(),
                                          "type":
                                              active[index].workType.toString(),
                                          "deadline": active[index]
                                              .jobDeadline
                                              .toString(),
                                          "jobTitle":
                                              active[index].jobTitle.toString(),
                                          "level":
                                              active[index].level.toString(),
                                          "salary":
                                              active[index].salary.toString(),
                                        }
                                      ]);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CircleAvatar(
                                                      radius: 20.0,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://ahaduvacancy.com/Uploads/Images/" +
                                                                active[index]
                                                                    .companyLogo
                                                                    .toString(),
                                                        progressIndicatorBuilder: (context,
                                                                url,
                                                                downloadProgress) =>
                                                            CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      )),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      child: Shimmer.fromColors(
                                                        baseColor: Colors.red,
                                                        highlightColor:
                                                            Colors.yellow,
                                                        child: Text(
                                                            active[index]
                                                                .jobTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                  ),
                                                  PopupMenuButton<_menuItem>(
                                                    onSelected: (value) {
                                                      switch (value) {
                                                        case _menuItem.open:
                                                          Get.to(
                                                              () => JobDetail(),
                                                              arguments: [
                                                                {
                                                                  "salary": active[
                                                                          index]
                                                                      .salary
                                                                      .toString(),
                                                                  "name": active[
                                                                          index]
                                                                      .companyName
                                                                      .toString(),
                                                                  "Description": active[
                                                                          index]
                                                                      .jobDescription
                                                                      .toString(),
                                                                  "logo": active[
                                                                          index]
                                                                      .companyLogo
                                                                      .toString(),
                                                                  "location": active[
                                                                          index]
                                                                      .location
                                                                      .toString(),
                                                                  "id": active[
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  "type": active[
                                                                          index]
                                                                      .workType
                                                                      .toString(),
                                                                  "deadline": active[
                                                                          index]
                                                                      .jobDeadline
                                                                      .toString(),
                                                                  "jobTitle": active[
                                                                          index]
                                                                      .jobTitle
                                                                      .toString(),
                                                                  'level': active[
                                                                          index]
                                                                      .level
                                                                      .toString(),
                                                                }
                                                              ]);
                                                          break;
                                                        case _menuItem.favorite:
                                                          favoriteItem({
                                                            "salary":
                                                                active[index]
                                                                    .salary
                                                                    .toString(),
                                                            "name":
                                                                active[index]
                                                                    .companyName
                                                                    .toString(),
                                                            "Description": active[
                                                                    index]
                                                                .jobDescription
                                                                .toString(),
                                                            "logo":
                                                                active[index]
                                                                    .companyLogo
                                                                    .toString(),
                                                            "location":
                                                                active[index]
                                                                    .location
                                                                    .toString(),
                                                            "id": active[index]
                                                                .id
                                                                .toString(),
                                                            "type":
                                                                active[index]
                                                                    .workType
                                                                    .toString(),
                                                            "deadline":
                                                                active[index]
                                                                    .jobDeadline
                                                                    .toString(),
                                                            "jobTitle":
                                                                active[index]
                                                                    .jobTitle
                                                                    .toString(),
                                                            'level':
                                                                active[index]
                                                                    .level
                                                                    .toString(),
                                                          });
                                                          break;
                                                        case _menuItem.share:
                                                          try {
                                                            VocsyShare.text(
                                                                'Ahadu vacancy',
                                                                'https://ahaduvacancy.com/vacancy-detail.php?id=${active[index].id.toString()}',
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    PrimaryColor)),
                                                      ),
                                                      PopupMenuItem(
                                                          value: _menuItem
                                                              .favorite,
                                                          child: Text(
                                                              'Favorite',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color:
                                                                      PrimaryColor))),
                                                      PopupMenuItem(
                                                          value:
                                                              _menuItem.share,
                                                          child: Text("Share",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      PrimaryColor,
                                                                  fontFamily:
                                                                      'Poppins'))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: 200,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .location_city),
                                                              SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  active[index]
                                                                      .companyName
                                                                      .toString(),
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins'),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .location_on_outlined),
                                                              SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  active[index]
                                                                      .location
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(Icons
                                                                  .work_outline),
                                                              SizedBox(
                                                                  width: 10),
                                                              Expanded(
                                                                child: Text(
                                                                  active[index]
                                                                      .workType
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins'),
                                                                  softWrap:
                                                                      true,
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
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                          Icons.lock_clock),
                                                      Text(
                                                        active[index]
                                                            .jobDeadline
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins'),
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
                                ],
                              );
                            }
                            return InkWell(
                              onTap: () {
                                Get.to(() => JobDetail(), arguments: [
                                  {
                                    'id': active[index].id.toString(),
                                    "name":
                                        active[index].companyName.toString(),
                                    "Description":
                                        active[index].jobDescription.toString(),
                                    "logo":
                                        active[index].companyLogo.toString(),
                                    "location":
                                        active[index].location.toString(),
                                    "type": active[index].workType.toString(),
                                    "deadline":
                                        active[index].jobDeadline.toString(),
                                    "jobTitle":
                                        active[index].jobTitle.toString(),
                                    "level": active[index].level.toString(),
                                    "salary": active[index].salary.toString(),
                                  }
                                ]);
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                          active[index]
                                                              .companyLogo
                                                              .toString(),
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.red,
                                                  highlightColor: Colors.yellow,
                                                  child: Text(
                                                      active[index]
                                                          .jobTitle
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                            PopupMenuButton<_menuItem>(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case _menuItem.open:
                                                    Get.to(() => JobDetail(),
                                                        arguments: [
                                                          {
                                                            "salary":
                                                                active[index]
                                                                    .salary
                                                                    .toString(),
                                                            "name":
                                                                active[index]
                                                                    .companyName
                                                                    .toString(),
                                                            "Description": active[
                                                                    index]
                                                                .jobDescription
                                                                .toString(),
                                                            "logo":
                                                                active[index]
                                                                    .companyLogo
                                                                    .toString(),
                                                            "location":
                                                                active[index]
                                                                    .location
                                                                    .toString(),
                                                            "id": active[index]
                                                                .id
                                                                .toString(),
                                                            "type":
                                                                active[index]
                                                                    .workType
                                                                    .toString(),
                                                            "deadline":
                                                                active[index]
                                                                    .jobDeadline
                                                                    .toString(),
                                                            "jobTitle":
                                                                active[index]
                                                                    .jobTitle
                                                                    .toString(),
                                                            'level':
                                                                active[index]
                                                                    .level
                                                                    .toString(),
                                                          }
                                                        ]);
                                                    break;
                                                  case _menuItem.favorite:
                                                    favoriteItem({
                                                      "salary": active[index]
                                                          .salary
                                                          .toString(),
                                                      "name": active[index]
                                                          .companyName
                                                          .toString(),
                                                      "Description":
                                                          active[index]
                                                              .jobDescription
                                                              .toString(),
                                                      "logo": active[index]
                                                          .companyLogo
                                                          .toString(),
                                                      "location": active[index]
                                                          .location
                                                          .toString(),
                                                      "id": active[index]
                                                          .id
                                                          .toString(),
                                                      "type": active[index]
                                                          .workType
                                                          .toString(),
                                                      "deadline": active[index]
                                                          .jobDeadline
                                                          .toString(),
                                                      "jobTitle": active[index]
                                                          .jobTitle
                                                          .toString(),
                                                      'level': active[index]
                                                          .level
                                                          .toString(),
                                                    });
                                                    break;
                                                  case _menuItem.share:
                                                    try {
                                                      VocsyShare.text(
                                                          'Ahadu vacancy',
                                                          'https://ahaduvacancy.com/vacancy-detail.php?id=${active[index].id.toString()}',
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: PrimaryColor)),
                                                ),
                                                PopupMenuItem(
                                                    value: _menuItem.favorite,
                                                    child: Text('Favorite',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Poppins',
                                                            color:
                                                                PrimaryColor))),
                                                PopupMenuItem(
                                                    value: _menuItem.share,
                                                    child: Text("Share",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: PrimaryColor,
                                                            fontFamily:
                                                                'Poppins'))),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .location_city),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            active[index]
                                                                .companyName
                                                                .toString(),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .location_on_outlined),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            active[index]
                                                                .location
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.work_outline),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            active[index]
                                                                .workType
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins'),
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
                                                  active[index]
                                                      .jobDeadline
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins'),
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
                          }),
                    );
                  } else if (snapshot.hasError) {
                    refresh();
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, i) {
                          return getShimmerLoading();
                        });
                  }

                  return ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, i) {
                        return getShimmerLoading();
                      });
                },
              ),
            )));
  }

  Shimmer getShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
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
                      borderRadius: BorderRadius.all(Radius.circular(15))),
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
      ),
    );
  }

  Future<void> _scrolListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent * 0.95 &&
        !isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });
      if (hasMore) {
        await job();
      }
      setState(() {
        isLoadingMore = false;
        page = page + 1;
        hasMore = posts.length < _maxlength;
      });
    }
  }

  Future<void> _pullRefresh() async {
    List<Jobs> fresh = await job();
    setState(() {
      _future = Future.value(fresh);
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class ExceptionHandlers {
  getExceptionString(error) {
    if (error is SocketException) {
      return 'No internet connection.';
    } else if (error is HttpException) {
      return 'HTTP error occured.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'Request timedout.';
    } else if (error is BadRequestException) {
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return error.message.toString();
    } else if (error is NotFoundException) {
      return error.message.toString();
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else {
      return 'Unknown error occured.';
    }
  }
}

class AppException implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppException([this.message, this.prefix, this.url]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad request', url);
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
      : super(message, 'Unable to process the request', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Api not responding', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'Unauthorized request', url);
}

class NotFoundException extends AppException {
  NotFoundException([String? message, String? url])
      : super(message, 'Page not found', url);
}

dynamic _processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson = (json.decode(response.body) as List)
          .map((e) => Jobs.fromJson(e))
          .toList();
      return responseJson;
    case 400: //Bad request
      throw BadRequestException(jsonDecode(response.body)['message']);
    case 401: //Unauthorized
      throw UnAuthorizedException(jsonDecode(response.body)['message']);
    case 403: //Forbidden
      throw UnAuthorizedException(jsonDecode(response.body)['message']);
    case 404: //Resource Not Found
      throw NotFoundException(jsonDecode(response.body)['message']);
    case 500: //Internal Server Error
    default:
      throw FetchDataException('Something went wrong! ${response.statusCode}');
  }
}
