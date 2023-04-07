import 'dart:async';
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
      margin: EdgeInsets.only(top: 40.h),
      decoration: BoxDecoration(
          color: RestaurantTheme.primary,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.h), topRight: Radius.circular(4.h))),
      padding: EdgeInsets.all(3.w),
      child: Column(
        children: [
          Text(
            "Mitra Kami",
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
                    return Container(child: Text(""));
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

class SearchBottomSheet extends StatelessWidget {
  final TextEditingController textController;

  const SearchBottomSheet({required this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cari Resto Favoritmu Yuk!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Ketik nama Resto disini',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[300],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              suffixIcon: Icon(Icons.search),
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 10,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text('Result ${index + 1}'),
          //         onTap: () {},
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}


// class SearchFieldWithAutoSubmit extends StatefulWidget {
//   @override
//   _SearchFieldWithAutoSubmitState createState() => _SearchFieldWithAutoSubmitState();
// }

// class _SearchFieldWithAutoSubmitState extends State<SearchFieldWithAutoSubmit> {
//   final textController = TextEditingController();
//   Timer _debounce;

//   void _onSearchTextChanged(String text, MyProvider provider) {
//     if (_debounce?.isActive ?? false) _debounce.cancel();
//     _debounce = Timer(const Duration(milliseconds: 2000), () {
//       provider.search(text);
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: textController,
//       onChanged: (text) => _onSearchTextChanged(text, context.read<MyProvider>()),
//       decoration: InputDecoration(
//         hintText: 'Ketik nama Resto disini',
//         border: OutlineInputBorder(),
//         suffixIcon: Icon(Icons.search),
//       ),
//     );
//   }
// }

