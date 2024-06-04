import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dashflix/constants/api_status.dart';
import 'package:dashflix/constants/widgets/custom_app_bar.dart';
import 'package:dashflix/constants/widgets/custom_carousel.dart';
import 'package:dashflix/screens/now_playing_screen_module/bloc/now_playing_bloc.dart';
import 'package:dashflix/screens/now_playing_screen_module/screen/nowplaying_movie_list.dart';
import 'package:dashflix/screens/popular_movies_screen_module/api/fetch_movies_data.dart';
import 'package:dashflix/screens/popular_movies_screen_module/bloc/popular_movies_bloc.dart';
import 'package:dashflix/screens/popular_movies_screen_module/screen/popular_movies_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../now_playing_screen_module/api/fetch_nowplaying_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget create() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return FetchPopularMovies();
          },
        ),
        RepositoryProvider(
          create: (context) {
            return FetchNowPlayingMovies();
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return PopularMoviesBloc(popularMovies: context.read<FetchPopularMovies>())
              ..add(GetPopularMoviesEvent());
          },
          child: const HomeScreen(),
        ),
        BlocProvider(
          create: (BuildContext context) {
            return NowPlayingBloc(
              nowPlayingMovies: context.read<FetchNowPlayingMovies>(),
            )..add(GetNowPlayingEvent());
          },
          child: const HomeScreen(),
        ),
      ],
      child: const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<PopularMoviesBloc>().add(GetPopularMoviesEvent());
  // }
  int _current = 0;
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                BlocConsumer<NowPlayingBloc, NowPlayingState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is NowPlayingMoviesStates && state.status == ApiStatus.isLoaded) {
                      return Container(
                        margin: EdgeInsets.zero,
                        child: CarouselSlider(
                          items: [
                            getCarouselPage(
                                state.resultModel?[0].posterPath ?? '', 'Winter', '30', false),
                            getCarouselPage(
                                state.resultModel?[1].posterPath ?? '', 'Wedding', '15', true),
                            getCarouselPage(
                                state.resultModel?[2].posterPath ?? '', 'Summer', '50', false),
                            getCarouselPage(
                                state.resultModel?[3].posterPath ?? '', 'Modern', '25', true),
                          ],
                          //Slider Container properties
                          options: CarouselOptions(
                              height: 400.0,
                              autoPlay: true,
                              aspectRatio: 5 / 4,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration: const Duration(milliseconds: 1111),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.zero,
                        child: CarouselSlider(
                          items: const [],
                          //Slider Container properties
                          options: CarouselOptions(
                              height: 400.0,
                              autoPlay: true,
                              aspectRatio: 5 / 4,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration: const Duration(milliseconds: 1111),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(top: 355, left: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AnimatedSmoothIndicator(
                            activeIndex: _current,
                            count: 4,
                            effect: const ScaleEffect(
                              activeStrokeWidth: 5,
                              scale: 5,
                              spacing: 20,
                              dotColor: Colors.white,
                              paintStyle: PaintingStyle.fill,
                              activePaintStyle: PaintingStyle.stroke,
                              activeDotColor: Colors.white60,
                              dotHeight: 5,
                              dotWidth: 5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //#region -- Now Playing
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Now Showing',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        // elevation: 00,
                        minimumSize: const Size(100, 30),
                        side: const BorderSide(
                          width: 1,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NowPlayingMoviesList.create(),
                            ));
                      },
                      child: const Text(
                        'Show More',
                        style: TextStyle(
                          fontFamily: "Raleway",
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: BlocConsumer<NowPlayingBloc, NowPlayingState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is NowPlayingMoviesStates &&
                      (state.status == ApiStatus.isLoaded || state.status == ApiStatus.isAdding)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 5),
                      child: SizedBox(
                        height: 320,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 163,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: Container(
                                      height: 240,
                                      width: 163,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.lightBlueAccent.withOpacity(0.6),
                                            spreadRadius: 0.1,
                                            blurRadius: 15,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            'https://image.tmdb.org/t/p/w500/${state.resultModel?[index].posterPath}',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, left: 5),
                                    child: Text(
                                      state.resultModel?[index].title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0, left: 5),
                                    child: Row(
                                      children: [
                                        (state.resultModel?[index].voteAverage?.round() ?? 0) <= 6
                                            ? const Icon(Icons.star_half_rounded,
                                                color: Colors.yellow)
                                            : const Icon(Icons.star_rounded, color: Colors.yellow),
                                        Text(
                                          '${state.resultModel?[index].voteAverage?.toStringAsFixed(1) ?? ''}/10 Rating',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else if (state is NowPlayingMoviesStates &&
                      state.status == ApiStatus.isLoading) {
                    return Shimmer.fromColors(
                        baseColor: Colors.lightBlueAccent.shade100.withAlpha(100),
                        highlightColor: Colors.black26,
                        enabled: true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 5),
                          child: SizedBox(
                            height: 320,
                            child: ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 240,
                                      width: 163,
                                      child: Card(),
                                    ),
                                    SizedBox(
                                      height: 24,
                                      width: 143,
                                      child: Card(),
                                    ),
                                    SizedBox(
                                      height: 24,
                                      width: 123,
                                      child: Card(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ));
                  } else if (state is NowPlayingMoviesStates && state.status == ApiStatus.isError) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? '',
                        style: const TextStyle(color: Colors.lightBlueAccent),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            //endregion

            //#region -- Popular
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        // elevation: 00,
                        minimumSize: const Size(100, 30),
                        side: const BorderSide(width: 1, color: Colors.lightBlueAccent),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return PopularMoviesList.create();
                          },
                        ));
                      },
                      child: const Text(
                        'Show More',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: BlocConsumer<PopularMoviesBloc, PopularMoviesState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is PopularMoviesStates &&
                      (state.status == ApiStatus.isLoaded || state.status == ApiStatus.isAdding)) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8),
                                child: Container(
                                  height: 180,
                                  width: 123,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.lightBlueAccent.withOpacity(0.6),
                                        spreadRadius: 0.1,
                                        blurRadius: 15,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        'https://image.tmdb.org/t/p/w500/${state.resultModel?[index].posterPath}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0, left: 5),
                                      child: Text(
                                        state.resultModel?[index].title ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0, left: 5),
                                    child: Row(
                                      children: [
                                        (state.resultModel?[index].voteAverage?.round() ?? 0) <= 6
                                            ? const Icon(Icons.star_half_rounded,
                                                color: Colors.yellow)
                                            : const Icon(Icons.star_rounded, color: Colors.yellow),
                                        Text(
                                          '${state.resultModel?[index].voteAverage?.toStringAsFixed(1) ?? ''}/10 Rating',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, left: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.multitrack_audio_rounded,
                                          size: 20,
                                          color: Colors.lightBlueAccent,
                                        ),
                                        Text(
                                          " ${state.resultModel?[index].originalLanguage ?? ''}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0, left: 5),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          CupertinoIcons.calendar_today,
                                          size: 20,
                                          color: Colors.lightBlueAccent,
                                        ),
                                        Text(
                                          ' ${state.resultModel?[index].releaseDate ?? ' '}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is PopularMoviesStates && state.status == ApiStatus.isLoading) {
                    return Shimmer.fromColors(
                        baseColor: Colors.lightBlueAccent.shade100.withAlpha(100),
                        highlightColor: Colors.black26,
                        enabled: true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 5),
                          child: SizedBox(
                            height: 320,
                            child: ListView.builder(
                              itemCount: 3,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 180,
                                      width: 123,
                                      child: Card(),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 163,
                                          child: Card(),
                                        ),
                                        SizedBox(
                                          height: 24,
                                          width: 143,
                                          child: Card(),
                                        ),
                                        SizedBox(
                                          height: 24,
                                          width: 123,
                                          child: Card(),
                                        ),
                                        SizedBox(
                                          height: 24,
                                          width: 163,
                                          child: Card(),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ));
                  } else if (state is PopularMoviesStates && state.status == ApiStatus.isError) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? '',
                        style: const TextStyle(color: Colors.lightBlueAccent),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            //endregion
          ],
        ),
      ),
    );
  }
}
