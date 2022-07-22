import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../movie_detail/detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../main_page.dart';

class CardWidget extends ConsumerStatefulWidget {
  final ValueChanged<bool> searchAction;

  const CardWidget({Key? key, required this.searchAction}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

final pageNumberProvider =
ChangeNotifierProvider((ref) => PageNumberNotifier());

class PageNumberNotifier extends ChangeNotifier {
  int pageNumber = 1;

  void setPageNumber(int _pageNumber) {
    pageNumber = _pageNumber;
    notifyListeners();
  }
}

final loadingProvider = ChangeNotifierProvider((ref) => LoadingNotifier());

class LoadingNotifier extends ChangeNotifier {
  bool isLoading = false;

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}

class _CardWidgetState extends ConsumerState<CardWidget> {
  final scrollController = ScrollController();
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  void onScroll() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        selectedPage++;
        ref.read(pageNumberProvider).setPageNumber(selectedPage);
        widget.searchAction(true);
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Center(
        child: SizedBox(
          height: 600,
          child: Stack(children: [
            if (ref.watch(loadingProvider).isLoading == false && ref.watch(movieProvider).movieList.isEmpty)
              buildNotFoundArea("There are currently no movies to be shown. Please search for movies by searching"),
            if (ref.watch(movieProvider).movieList.isNotEmpty)
              CustomScrollView(
                  cacheExtent: 3000,
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: SliverGrid(
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 4.0,
                          mainAxisExtent: 180,
                        ),
                        delegate: SliverChildListDelegate(
                          [
                            for (var item in ref.watch(movieProvider).movieList)
                              buildCard(item)
                          ],
                        ),
                      ),
                    ),
                  ]),
            if (ref.watch(loadingProvider).isLoading == true)
              const Center(
                child: SizedBox(
                  width: 150,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotate,
                    colors: [Colors.orange],
                    strokeWidth: 15,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.transparent,
                  ),
                ),
              )
          ]),
        ),
      );
    });
  }

  Widget buildCard(Movie movie) {
    var mediaQuery = MediaQuery.of(context);
    double width = mediaQuery.size.width;

    double cardWidth = (width - 22 * 2 - 15) / 2;
    double cardHeight = cardWidth * 195 / 200;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      width: cardWidth,
      height: cardHeight,
      constraints: const BoxConstraints(maxHeight: 195, maxWidth: 155),
      child: GestureDetector(
        onTap: () {
          ref.read(loadingProvider).setLoading(true);
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailPage(movieId: movie.movieId, movieTitle: movie.title ?? "",),
            transitionDuration: Duration.zero,
          ));
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 180 / 140,
                    child: movie.posterPath != null
                        ? Image.network(
                        "http://image.tmdb.org/t/p/w500/" +
                            movie.posterPath!.toString(),
                        fit: BoxFit.contain)
                        : Image.asset(
                      'assets/images/no_image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 8,
                    child: Container(
                      width: 35,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 0,
                          )),
                      child: Center(child: Text(movie.voteAverage.toString())),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                color: Color(0xffD3D3D3),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SizedBox(
                    height: 30,
                    child: Text(
                      movie.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildNotFoundArea(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0) +
          const EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/not_search.jpg',
              fit: BoxFit.cover,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
