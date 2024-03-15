import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashflix/constants/api_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../api/fetch_movies_data.dart';
import '../bloc/popular_movies_bloc.dart';

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
        BlocProvider(
          create: (BuildContext context) =>
              PopularMoviesBloc(popularMovies: context.read<FetchPopularMovies>()),
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
  @override
  void initState() {
    super.initState();
    context.read<PopularMoviesBloc>().add(GetPopularMoviesEvent());
  }

  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 100,
              sigmaY: 100,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: const Text(
          'DashFlix',
          style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PopularMoviesBloc, PopularMoviesState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is PopularMoviesStates &&
                (state.status == ApiStatus.isLoaded || state.status == ApiStatus.isAdding)) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 5),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.extentAfter == 0) {
                      currentPage++;
                      if ((state.totalPages ?? 0) >= currentPage) {
                        context.read<PopularMoviesBloc>().add(GetPopularMoviesEvent());
                      }
                    }
                    return false;
                  },
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 9 / 16,
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 8.0, // spacing between rows
                      crossAxisSpacing: 8.0, // spacing between columns
                    ),
                    itemCount: (state.totalPages ?? 0) > currentPage
                        ? (state.resultModel?.length ?? 0) + 2
                        : (state.resultModel?.length ?? 0),
                    itemBuilder: (context, index) {
                      return (state.resultModel?.length ?? 0) > index
                          ? Card(
                              color: Colors.transparent,
                              semanticContainer: true,
                              elevation: 10,
                              shadowColor: Colors.lightBlueAccent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      'https://image.tmdb.org/t/p/w500/${state.resultModel?[index].posterPath}',
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 0, 0),
                                            Color.fromARGB(0, 31, 31, 31)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        // color: Color.fromARGB(255, 248, 67, 84)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(state.resultModel?[index].title ?? '',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Shimmer.fromColors(
                              baseColor: Colors.lightBlueAccent.shade700.withAlpha(70),
                              highlightColor: Colors.black26,
                              enabled: true,
                              child: const Card());
                    },
                  ),
                ),
              );
            } else if (state is PopularMoviesStates && state.status == ApiStatus.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.lightBlueAccent),
              );
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
    );
  }
}
