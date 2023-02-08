import 'package:ahadu/constants.dart';
import 'package:ahadu/screen/jobDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../noInternet.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Map<String, dynamic>> _items = [];
  final favoriteBox = Hive.box(FAVORITE_BOX);

  void refreshFavorite() {
    final data = favoriteBox.keys.map((key) {
      final item = favoriteBox.get(key);
      return {
        "key": key,
        'name': item['name'],
        'id': item['id'],
        'Description': item['Description'],
        'jobTitle': item['jobTitle'],
        'logo': item['logo'],
        'location': item['location'],
        'type': item['type'],
        'deadline': item['deadline'],
        'level': item['level']
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      print("Favorite items: ${_items.length}}");
    });
  }

  Future<void> deleteFavorite(int FavKey) async {
    await favoriteBox.delete(FavKey);
    refreshFavorite();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Favorite has been deleted')));
  }

  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    refreshFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Favorite",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PrimaryColor,
      ),
      body: _items.length == 0
          ? Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: EmptyFailureNoInternetView(
                  image: 'assets/lotties/empty.json',
                  title: 'No Favorite !',
                  description: '',
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final currentItem = _items[index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => JobDetail(), arguments: [
                          {
                            "name": currentItem['name'],
                            "Description": currentItem['Description'],
                            "logo": currentItem['logo'],
                            "salary": currentItem['salary'],
                            "type": currentItem['type'],
                            "deadline": currentItem['deadline'],
                            "jobTitle": currentItem['jobTitle'],
                            'level': currentItem['level'],
                            'id': currentItem['id'],
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
                                                  currentItem['logo'],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: Text(currentItem['name'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () =>
                                            deleteFavorite(currentItem['key']),
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ))
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
                                                    currentItem['name'],
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                    ),
                                                    softWrap: true,
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
                                                      currentItem['location'],
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.work_outline),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                      currentItem['type'],
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                      )),
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
                                        Text(currentItem['deadline'],
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            )),
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
                  },
                );
              }),
    );
  }
}
