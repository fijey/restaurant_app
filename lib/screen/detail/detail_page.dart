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
                      if (state.state == ResultStateDetail.hasData) {
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
                      } else if (state.state == ResultStateDetail.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResultStateDetail.error) {
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
                      if (state.state == ResultStateDetail.hasData) {
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
                      } else if (state.state == ResultStateDetail.loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.state == ResultStateDetail.error) {
                        return Text(state.message);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Consumer<RestaurantDetailProvider>(
                  builder: (context, state, _) {
                    if (state.state == ResultStateDetail.hasData) {
                      return SizedBox(
                        height: 46.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer Reviews',
                              style: RestaurantTheme.styleHeadingPrimary,
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SizedBox(
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
                    } else if (state.state == ResultStateDetail.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.state == ResultStateDetail.error) {
                      return Text(state.message);
                    } else {
                      return Container();
                    }
                  },
                ),
                const ReviewForm(),
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

class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Column(
        children: [
          Text('Berikan Review', style: RestaurantTheme.styleHeadingPrimary),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Review',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Review harus diisi';
                      }
                      return null;
                    },
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => RestaurantTheme.primary,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Send review
                        String name = _nameController.text;
                        String review = _reviewController.text;
                        double rating = _rating;
                        // Provider.of<RestaurantProvider>(context, listen: false)
                        //     .addReview(name, review, rating);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
