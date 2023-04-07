import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:restaurant_app/common/restaurant_theme.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_model.dart';
import 'package:restaurant_app/data/provider/restaurant_detail_provider.dart';

class DetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const DetailPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RestaurantTheme.primary,
        title: const Text('Detail Page'),
      ),
      body: ChangeNotifierProvider<RestaurantDetailProvider>(
        create: (context) => RestaurantDetailProvider(
            apiService: ApiService(), id: restaurant.id),
        child: DetailCard(restaurant: restaurant),
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'restaurant_${restaurant.id}', // tag untuk animasi hero
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(restaurant.pictureId),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant.city.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(
                            "(${restaurant.rating.toString()})",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  restaurant.description,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Menu:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: Consumer<RestaurantDetailProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultState.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.result.menus.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 40.w,
                              height: 10.w,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  color: RestaurantTheme.secondary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.result.menus[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state.state == ResultState.loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResultState.error) {
                        return Text(state.message);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Drinks:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: Consumer<RestaurantDetailProvider>(
                    builder: (context, state, _) {
                      if (state.state == ResultState.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.result.drinks.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 40.w,
                              height: 10.w,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Card(
                                  color: RestaurantTheme.secondary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          state.result.drinks[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state.state == ResultState.loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResultState.error) {
                        return Text(state.message);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Consumer<RestaurantDetailProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultState.hasData) {
                      return Container(
                        height: 50.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Reviews',
                              style: RestaurantTheme.styleHeadingPrimary,
                            ),
                            SizedBox(height: 16),
                            Expanded(
                              child: Container(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: state.result.review.length,
                                  itemBuilder: (context, index) {
                                    return CustomerReviewWidget(
                                      name: state.result.review[index].name,
                                      review: state.result.review[index].review,
                                      date: state.result.review[index].date,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.state == ResultState.loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.state == ResultState.error) {
                      return Text(state.message);
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerReviewWidget extends StatelessWidget {
  final String name;
  final String review;
  final String date;

  const CustomerReviewWidget({
    Key? key,
    required this.name,
    required this.review,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: RestaurantTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              review,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
