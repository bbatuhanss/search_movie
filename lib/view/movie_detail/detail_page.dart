import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../models/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/movie_service.dart';
import '../movie/movie_card_widget.dart';

class DetailPage extends ConsumerStatefulWidget {
  final int movieId;
  final String movieTitle;

  const DetailPage({Key? key, required this.movieId, required this.movieTitle}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

final movieDataProvider = ChangeNotifierProvider((ref) => MovieDataNotifier());

class MovieDataNotifier extends ChangeNotifier {
  late Movie movie;

  void setMovieData(Movie _movie) {
    movie = _movie;
    notifyListeners();
  }
}

class _DetailPageState extends ConsumerState<DetailPage> {

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  Future<void> asyncInit() async {
    await getDetailData(widget.movieId);
  }

  Future<void> getDetailData(int movieId) async {
    try {
      Movie movieData = await MovieService().getDetailMovie(movieId);
      ref.read(movieDataProvider).setMovieData(movieData);
      ref.read(loadingProvider).setLoading(false);
    } catch (err) {
      ref.read(loadingProvider).setLoading(false);
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
        elevation: 2,
        toolbarHeight: 60,
        backgroundColor: Colors.orange.withOpacity(0.6),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Theme(
          data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent,
          ),
          child: Text(
            widget.movieTitle,
            style: const TextStyle(fontSize: 17, color: Color(0xff011633)),
          ),
        ),
      ),
      body: ref.watch(loadingProvider).isLoading == false
          ? Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                    image:
                        ref.watch(movieDataProvider).movie.backdropPath != null
                            ? NetworkImage(
                                "http://image.tmdb.org/t/p/w500/" +
                                    ref
                                        .watch(movieDataProvider)
                                        .movie
                                        .backdropPath!,
                              )
                            : const AssetImage(
                                'assets/images/no_image.png',
                              ) as ImageProvider,
                  )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    if (ref
                                            .watch(movieDataProvider)
                                            .movie
                                            .posterPath !=
                                        null)
                                      Image.network(
                                          "http://image.tmdb.org/t/p/w500/" +
                                              ref
                                                  .watch(movieDataProvider)
                                                  .movie
                                                  .posterPath!,
                                          fit: BoxFit.contain,
                                          height: 250),
                                    if (ref
                                            .watch(movieDataProvider)
                                            .movie
                                            .posterPath ==
                                        null)
                                      Image.asset('assets/images/no_image.png',
                                          fit: BoxFit.cover, height: 200),
                                    Positioned(
                                      bottom: 15,
                                      left: 8,
                                      child: Container(
                                        width: 40,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 0,
                                            )),
                                        child: Center(
                                            child: Text(
                                          ref
                                              .watch(movieDataProvider)
                                              .movie
                                              .voteAverage!
                                              .toString(),
                                          style: const TextStyle(fontSize: 18),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ref
                                          .read(movieDataProvider)
                                          .movie
                                          .overview!,
                                      maxLines: 9,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Wrap(
                                      spacing: 7,
                                      runSpacing: 7,
                                      alignment: WrapAlignment.start,
                                      children: [
                                        if (ref.read(movieDataProvider).movie.genresList!.isNotEmpty)
                                          const Text(
                                            "Genres:",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        for (var item in ref.read(movieDataProvider).movie.genresList!)
                                          Text(
                                            item["name"] +
                                                ((ref.read(movieDataProvider).movie.genresList!.last == item)
                                                    ? ""
                                                    : ","),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(
              child: SizedBox(
                width: 200,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotate,
                  colors: [Colors.orange],
                  strokeWidth: 10,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              ),
            ),
    );
  }
}
