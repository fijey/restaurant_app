import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:restaurant_app/common/card_decoration.dart';
import 'package:restaurant_app/common/restaurant_theme.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/provider/restaurant_search_provider.dart';
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
              height: 28.h,
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
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            backgroundColor: RestaurantTheme.secondary,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SearchBottomSheet(
                                textController: TextEditingController(),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: RestaurantTheme.secondary,
                          ),
                          child: const Center(
                            child: Text(
                              'Cari makanan atau restoran favoritmu!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Selamat Datang Fajar\n',
                              style: RestaurantTheme.welcomeText
                                  .copyWith(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'LAPER? ',
                              style: RestaurantTheme.welcomeText,
                            ),
                            TextSpan(
                              text: 'Yuk segera pilih Resto Favoritmu',
                              style: RestaurantTheme.welcomeText
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Divider(),
                      Stack(
                        children: [
                          Consumer<RestaurantProvider>(
                            builder: (context, state, _) {
                              if (state.state == ResultState.hasData) {
                                return MitraCard(
                                  restaurantList: state.restaurantListFiltered,
                                );
                              } else if (state.state == ResultState.error) {
                                return Container(
                                    margin: EdgeInsets.only(top: 55.h),
                                    child: Center(child: Text(state.message)));
                              } else if (state.state == ResultState.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state.state == ResultState.noData) {
                                return Container(
                                    margin: EdgeInsets.only(top: 55.h),
                                    child: Center(child: Text(state.message)));
                              } else {
                                return const Text("");
                              }
                            },
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: ContainerDecoration.cardDecoration(),
                            height: 41.h,
                            width: 100.w,
                            child: Consumer<RestaurantProvider>(
                              builder: (BuildContext context, state, _) {
                                if (state.state == ResultState.hasData) {
                                  return FavoritCard(
                                      favoriteRestaurants:
                                          state.result_favorite);
                                } else if (state.state == ResultState.error) {
                                  return Container(
                                      margin: EdgeInsets.only(top: 55.h),
                                      child:
                                          Center(child: Text(state.message)));
                                } else if (state.state == ResultState.loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state.state == ResultState.noData) {
                                  return Center(child: Text(state.message));
                                } else {
                                  return Container(child: const Text(""));
                                }
                              },
                            ),
                          ),
                        ],
                      )
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
      padding: EdgeInsets.only(top: 5.h, left: 4.h, right: 4.h),
      margin: EdgeInsets.only(top: 40.h),
      decoration: BoxDecoration(
          color: RestaurantTheme.primary,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.h), topRight: Radius.circular(4.h))),
      child: Column(
        children: [
          Text(
            "Restaurant Yang Mungkin Kamu Suka",
            style: RestaurantTheme.titleOnCard.copyWith(color: Colors.white),
          ),
          SizedBox(
            height: 4.h,
          ),
          ChangeNotifierProvider<RestaurantProvider>(
            create: (BuildContext context) {
              return RestaurantProvider(apiService: ApiService());
            },
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
                            padding: EdgeInsets.all(4.w),
                            margin: EdgeInsets.only(top: 3.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: Hero(
                                    tag: "restaurant_${state.result[index].id}",
                                    child: CachedNetworkImage(
                                      width: 100.w,
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
                                  style: RestaurantTheme.titleOnCard,
                                ),
                                const SizedBox(height: 8.0),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5.w,
                                      right: 5.w,
                                      top: 1.h,
                                      bottom: 1.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.w),
                                      color: RestaurantTheme.primary),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                            style: RestaurantTheme.titleOnCard,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 8.0),
                                          const Icon(
                                            Icons.star,
                                            size: 16.0,
                                            color: RestaurantTheme.heading2,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            state.result[index].rating
                                                .toString(),
                                            style: RestaurantTheme.titleOnCard,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
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
                    return Container(child: const Text(""));
                  }
                },
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
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Hero(
                                      tag:
                                          "restaurant_${favoriteRestaurants[index].id}",
                                      child: CachedNetworkImage(
                                        width: 50.w,
                                        height: 23.h,
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
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 2.3.w,
                                        right: 2.3.w,
                                        top: 1.h,
                                        bottom: 1.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.w),
                                        color: RestaurantTheme.primary),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          favoriteRestaurants[index]
                                              .rating
                                              .toString(),
                                          style: RestaurantTheme.titleOnCard
                                              .copyWith(fontSize: 17.sp),
                                        ),
                                        const Icon(Icons.star,
                                            color: RestaurantTheme.heading2,
                                            size: 16),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
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

class SearchBottomSheet extends StatefulWidget {
  final TextEditingController textController;

  const SearchBottomSheet({super.key, required this.textController});

  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  Timer? _debounce;

  @override
  void dispose() {
    // Clear the timer when the widget is disposed
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cari Resto Favoritmu Yuk!',
                style:
                    RestaurantTheme.titleOnCard.copyWith(color: Colors.white),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          TextField(
            controller: widget.textController,
            decoration: InputDecoration(
              hintText: 'Ketik nama Resto disini',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              suffixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) {
              // Clear the timer and start a new one when the user types
              _debounce?.cancel();
              _debounce = Timer(const Duration(seconds: 2), () {
                final restaurantSearchProvider =
                    Provider.of<RestaurantSearchProvider>(context,
                        listen: false);
                restaurantSearchProvider.searchRestaurant(query: value);
              });
            },
          ),
          Consumer<RestaurantSearchProvider>(
            builder: (context, state, child) {
              if (state.state == ResultStateSearch.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.result.length,
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
                                          restaurant: state.result[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                              color: RestaurantTheme.primary,
                              borderRadius: BorderRadius.circular(5.w)),
                          margin: EdgeInsets.only(top: 4.h),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: ClipOval(
                                  child: Hero(
                                    tag: "restaurant_${state.result[index].id}",
                                    child: CachedNetworkImage(
                                      width: 20.w,
                                      height: 20.h,
                                      fit: BoxFit.cover,
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
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.result[index].name,
                                        style: RestaurantTheme.titleOnCard),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.result[index].city,
                                          style: RestaurantTheme.titleOnCard,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 16, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.result[index].rating.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state.state == ResultStateSearch.error) {
                return Container(
                  margin: EdgeInsets.only(top: 30.h),
                  child: Center(child: Text(state.message)),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
