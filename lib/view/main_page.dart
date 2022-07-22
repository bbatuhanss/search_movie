import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import 'movie/movie_card_widget.dart';
import '../models/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

final movieProvider = ChangeNotifierProvider((ref) => MovieNotifier());

class MovieNotifier extends ChangeNotifier {
  List<Movie> movieList = [];

  void setMovie(List<Movie> _listMovie) {
    movieList = _listMovie;
    notifyListeners();
  }
}

class _MainPageState extends ConsumerState<MainPage> {
  FocusNode focusNode = FocusNode();
  final searchController = TextEditingController();
  List<Movie> moviesList = [];
  String searchHintText = "Search...";
  String searctText = "";


  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          searchHintText = "";
        });
      } else {
        setState(() {
          searchHintText =  "Search...";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          toolbarHeight: 80,
          backgroundColor: Colors.orange.withOpacity(0.6),
          automaticallyImplyLeading: false,
          title: Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.transparent,
            ),
            child: SizedBox(
              width: 350,
              child: buildSearch(),
            ),
          ),
        ),
        body: CardWidget(
          searchAction: (value) {
            if (value == true) {
              getMovieList(searchController.text);
            }
          },
        )
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  Widget buildSearch() {
    return Row(
      children: [
        const SizedBox(width: 22),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: searchController,
              focusNode: focusNode,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: searchHintText,
                alignLabelWithHint: false,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Color(0xffE5E5E5), width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: const Color(0xfff5f5f5),
                isDense: true,
                contentPadding: const EdgeInsets.all(8),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      moviesList = [];
                      searchController.text = '';
                      ref.read(movieProvider).setMovie([]);
                      ref.read(pageNumberProvider).setPageNumber(1);
                    });
                  },
                ),
              ),

              onChanged: (value) {
                setState(() {
                  moviesList = [];
                  ref.read(pageNumberProvider).setPageNumber(1);
                  // searchText'i value ile kontrol etmemin sebebi value'nun length'i 2 den büyük olduğu durumlarda sadece bir kere girmesini sağlamak içindir.
                  //Çünkü TextFormField onChanged de birden fazla girip servisi bir den fazla call ediyor. Böyle bir bug var flutterın issueslarda açılmış ancak bir çözüm yapılmamış.
                  //https://github.com/flutter/flutter/issues/50163 hata bu adreste.
                  if (value.length >= 2 && searctText != value) {
                    getMovieList(value);
                  }
                  if(value.isEmpty){
                    ref.read(movieProvider).setMovie([]);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getMovieList(String query) async {
    try {
      setState(() {
        searctText = query;
      });
      ref.read(loadingProvider).setLoading(true);
      List<Movie> movieList = await MovieService().getSearchMovie(query,ref.read(pageNumberProvider).pageNumber);
      moviesList = [...moviesList, ...movieList];
      ref.read(movieProvider).setMovie(moviesList);
      ref.read(loadingProvider).setLoading(false);
    } catch (err) {
      ref.read(loadingProvider).setLoading(false);
      print(err);
    }
  }
}
