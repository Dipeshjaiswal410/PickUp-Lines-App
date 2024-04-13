// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickup_lines/Internet_Connectivity_Bloc/internet_bloc.dart';
import 'package:pickup_lines/Internet_Connectivity_Bloc/internet_state.dart';

import 'package:pickup_lines/constraints.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class FavoriteLinesScreen extends StatefulWidget {
  const FavoriteLinesScreen({
    Key? key,
    required this.favoriteItemsList,
  }) : super(key: key);
  final List<String> favoriteItemsList;

  @override
  State<FavoriteLinesScreen> createState() => _FavoriteLinesScreenState();
}

class _FavoriteLinesScreenState extends State<FavoriteLinesScreen> {
  final translator = GoogleTranslator();

  late List<bool> isFavoriteList; // Track favorite status for each item
  late List<String?> translatedTextList;
  // Add a variable to track translation button color
  late List<Color> translationButtonColors;

  @override
  void initState() {
    super.initState();
    isFavoriteList = [];
    //_initializeFavorites();
    translatedTextList = List.filled(widget.favoriteItemsList.length, null);
    // Initialize button colors
    translationButtonColors = List.filled(
        widget.favoriteItemsList.length, Colors.white); // Initial color
  }

  //Remove a string from my_favourite
  removeStringFromFavorite(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList(item) ?? [];
    favoriteList.remove(item);
    setState(() {
      widget.favoriteItemsList.remove(item);
    });
    await prefs.setStringList(item, favoriteList);
  }

  // Translation Function
  Future<void> translateToNepali(int index) async {
    Translation translation =
        await translator.translate(widget.favoriteItemsList[index], to: 'ne');
    setState(() {
      translatedTextList[index] = translation.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          "Favorite Lines",
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width / 15,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.favoriteItemsList.isNotEmpty
          ? ListView.builder(
              itemCount: widget.favoriteItemsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
                  child: Card(
                    elevation: 7,
                    shadowColor: Colors.black,
                    child: Container(
                      height: size.height / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Colors.lightBlueAccent, Colors.yellow],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                """ "${widget.favoriteItemsList[index]}" """,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: size.width / 14,
                                    fontWeight: FontWeight.bold,
                                    shadows: const <Shadow>[
                                      Shadow(
                                          color: Colors.white,
                                          offset: Offset(0.5, 0.1)),
                                    ]),
                              ),
                            ),
                          ),
                          if (translatedTextList[index] != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 7,
                                right: 7,
                                top: 7,
                              ),
                              child: Text(
                                """ "${translatedTextList[index]!}" """,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: size.width / 30),
                              ),
                            ),
                          const Divider(
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Elevation button for favorite icon
                              ElevatedButton(
                                onPressed: () {
                                  removeStringFromFavorite(
                                      widget.favoriteItemsList[index]);
                                },
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5)),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              //Elevation button for translation icon
                              ElevatedButton(
                                onPressed: () async {
                                  final internetCheck =
                                      context.read<InternetBloc>();
                                  final currentState = internetCheck.state;
                                  if (currentState is InternetGainedState) {
                                    await translateToNepali(index);
                                    // Toggle button color
                                    setState(() {
                                      translationButtonColors[
                                          index] = translationButtonColors[
                                                  index] ==
                                              Colors.yellow
                                          ? Colors
                                              .yellow // Change to your desired color
                                          : Colors.yellow;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor:
                                          Colors.red.withOpacity(0.9),
                                      duration: const Duration(seconds: 2),
                                      content: const Text(
                                        "No internet connection...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5),
                                    //primary: translationButtonColors[index],
                                    ),
                                child: const Icon(
                                  Icons.g_translate_sharp,
                                  color: Colors.black,
                                ),
                              ),
                              //Elevation button for share icon
                              ElevatedButton(
                                onPressed: () async {
                                  final internetCheck =
                                      context.read<InternetBloc>();
                                  final currentState = internetCheck.state;
                                  if (currentState is InternetGainedState) {
                                    await Share.share(
                                        widget.favoriteItemsList[index]);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor:
                                          Colors.red.withOpacity(0.9),
                                      duration: const Duration(seconds: 2),
                                      content: const Text(
                                        "No internet connection...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.black,
                                    elevation: 5,
                                    side: const BorderSide(
                                        color: Colors.black, width: 0.5)),
                                child: const Icon(
                                  Icons.share,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                "Your Favorite Lines Will Be Appear Here...",
                style: TextStyle(),
              ),
            ),
    );
  }
}
