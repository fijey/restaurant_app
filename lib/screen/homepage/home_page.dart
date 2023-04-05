import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/screen/detail/detail_page.dart';
import 'package:restaurant_app/screen/homepage/controller/controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _restaurantList = [];
  List<dynamic> _restaurantFavorite = [];
  HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    if (mounted) {
      String jsonRestaurantData = await controller.loadRestaurants();
      setState(() {
        _restaurantList = json
            .decode(jsonRestaurantData)['restaurants']
            .map((restaurant) =>
                Restaurant.fromJson(restaurant as Map<String, dynamic>))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement widget build
    List<dynamic> favoriteRestaurants =
        controller.sortFavorite(_restaurantList).take(3).toList();

// Step 1: Buat list baru sebagai data sumber daftar mitra
    List<dynamic> _restaurantListFiltered = List.from(_restaurantList);

// Step 2: Hapus item-item favorit dari _restaurantListFiltered
    _restaurantListFiltered
        .removeWhere((restaurant) => favoriteRestaurants.contains(restaurant));

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Selamat Datang Fajar',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontStyle: FontStyle.italic,
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      height: 39.h,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _restaurantList.isNotEmpty
                          ? Column(
                              children: [
                                Text(
                                  "Restaurant Terfavorit",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  height: 30.h,
                                  margin: EdgeInsets.only(top: 2.h),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: favoriteRestaurants.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(seconds: 2),
                                              pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) =>
                                                  DetailPage(
                                                      restaurant:
                                                          favoriteRestaurants[
                                                              index]),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Hero(
                                                  tag:
                                                      "restaurant_${favoriteRestaurants[index].id}",
                                                  child: CachedNetworkImage(
                                                    width: 120,
                                                    height: 120,
                                                    imageUrl:
                                                        favoriteRestaurants[
                                                                index]
                                                            .pictureId,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w,
                                                              vertical: 5.w),
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                favoriteRestaurants[index].name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star,
                                                      color: Colors.amber,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    favoriteRestaurants[index]
                                                        .rating
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator()),
                    ),
                    Divider(),
                    Text(
                      "Mitra Kami",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        height: 60.h,
                        child: ListView.builder(
                          itemCount: _restaurantListFiltered.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 2),
                                      pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) =>
                                          DetailPage(
                                              restaurant:
                                                  _restaurantListFiltered[
                                                      index])),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Hero(
                                        tag:
                                            "restaurant_${_restaurantListFiltered[index].id}",
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          height: 30.h,
                                          imageUrl:
                                              _restaurantListFiltered[index]
                                                  .pictureId,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 35.w,
                                                vertical: 20.w),
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      _restaurantListFiltered[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    // Text(
                                    //   _restaurantListFiltered[index].description,
                                    //   style: TextStyle(
                                    //     fontSize: 14.0,
                                    //     color: Colors.grey[600],
                                    //   ),
                                    // ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          size: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          _restaurantListFiltered[index].city,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Icon(
                                          Icons.star,
                                          size: 16.0,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          _restaurantListFiltered[index]
                                              .rating
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
