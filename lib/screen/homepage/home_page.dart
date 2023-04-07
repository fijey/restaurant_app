import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:restaurant_app/common/card_decoration.dart';
import 'package:restaurant_app/common/restaurant_theme.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/screen/detail/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement widget build
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 30.h,
              decoration: const BoxDecoration(
                color: RestaurantTheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            ChangeNotifierProvider<RestaurantProvider>(
              create: (context) => RestaurantProvider(apiService: ApiService()),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang Fajar\nLaper? Yuk Cari Tempat Makan Di Kota Terdekat Kamu!',
                        textAlign: TextAlign.start,
                        style: RestaurantTheme.welcomeText,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Divider(),
                      Container(
                        decoration: ContainerDecoration.cardDecoration(),
                        height: 40.h,
                        width: 100.w,
                        child: Consumer<RestaurantProvider>(
                          builder: (BuildContext context, state, _) {
                            if (state.state == ResultState.hasData) {
                              return FavoritCard(
                                  favoriteRestaurants: state.result_favorite);
                            } else if (state.state == ResultState.error) {
                              return Text(state.message);
                            } else if (state.state == ResultState.loading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state.state == ResultState.noData) {
                              return Text(state.message);
                            } else {
                              return Container(child: Text(""));
                            }
                          },
                        ),
                      ),
                      const Divider(),
                      Consumer<RestaurantProvider>(
                        builder: (context, state, _) {
                          if (state.state == ResultState.hasData) {
                            return MitraCard(
                              restaurantList: state.restaurantListFiltered,
                            );
                          } else if (state.state == ResultState.error) {
                            return Text(state.message);
                          } else if (state.state == ResultState.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state.state == ResultState.noData) {
                            return Text(state.message);
                          } else {
                            return Container(child: Text(""));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MitraCard extends StatelessWidget {
  List<Restaurant> restaurantList;
  MitraCard({super.key, required this.restaurantList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Column(
        children: [
          Text(
            "Mitra Kami",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 3.h,
          ),
          ChangeNotifierProvider<RestaurantProvider>(
            create: (BuildContext context) {
              return RestaurantProvider(apiService: ApiService());
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: 70.h,
                child: Consumer<RestaurantProvider>(
                  builder: (BuildContext context, state, _) {
                    if (state.state == ResultState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.state == ResultState.hasData) {
                      return ListView.builder(
                        itemCount: state.result.length,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(seconds: 2),
                                    pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) =>
                                        DetailPage(
                                            restaurant: state.result[index])),
                              );
                            },
                            child: Container(
                              decoration: ContainerDecoration.cardDecoration(),
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: Hero(
                                      tag:
                                          "restaurant_${state.result[index].id}",
                                      child: CachedNetworkImage(
                                        width: double.infinity,
                                        height: 30.h,
                                        imageUrl: state.result[index].pictureId,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 35.w, vertical: 20.w),
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    state.result[index].name,
                                    style: RestaurantTheme.titleOnCard.copyWith(
                                        color: RestaurantTheme.primary),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        size: 16.0,
                                        color: RestaurantTheme.heading2,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        state.result[index].city,
                                        style: RestaurantTheme.titleOnCard
                                            .copyWith(
                                                color: RestaurantTheme.primary),
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Icon(
                                        Icons.star,
                                        size: 16.0,
                                        color: RestaurantTheme.heading2,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        state.result[index].rating.toString(),
                                        style: RestaurantTheme.titleOnCard
                                            .copyWith(
                                                color: RestaurantTheme.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state.state == ResultState.noData) {
                      return Container(
                        child: Text(state.message),
                      );
                    } else if (state.state == ResultState.error) {
                      return Container(
                        child: Text(state.message),
                      );
                    } else {
                      return Container(child: Text(""));
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritCard extends StatelessWidget {
  List<Restaurant> favoriteRestaurants;
  FavoritCard({super.key, required this.favoriteRestaurants});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 3.h,
        ),
        Expanded(
          // height: 40.h,
          // decoration: ContainerDecoration.cardDecoration(),
          child: favoriteRestaurants.isNotEmpty
              ? Column(
                  children: [
                    Text("Restaurant Terfavorit",
                        style: RestaurantTheme.titleOnCard),
                    Expanded(
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
                                      const Duration(seconds: 2),
                                  pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) =>
                                      DetailPage(
                                          restaurant:
                                              favoriteRestaurants[index]),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Hero(
                                      tag:
                                          "restaurant_${favoriteRestaurants[index].id}",
                                      child: CachedNetworkImage(
                                        width: 180,
                                        height: 140,
                                        fit: BoxFit.cover,
                                        imageUrl: favoriteRestaurants[index]
                                            .pictureId,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 5.w),
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(favoriteRestaurants[index].name,
                                      style: RestaurantTheme.titleOnCard
                                          .copyWith(fontSize: 17.sp)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        favoriteRestaurants[index]
                                            .rating
                                            .toString(),
                                        style: RestaurantTheme.titleOnCard
                                            .copyWith(fontSize: 17.sp),
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
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
