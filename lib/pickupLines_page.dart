// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'package:pickup_lines/Internet_Connectivity_Bloc/internet_bloc.dart';
import 'package:pickup_lines/Internet_Connectivity_Bloc/internet_state.dart';
import 'package:pickup_lines/SharedPreference_file.dart';
import 'package:pickup_lines/constraints.dart';

class PickUpLinesScreen extends StatefulWidget {
  const PickUpLinesScreen({
    Key? key,
    required this.appBarTitle,
    required this.listOfLines,
    required this.topicColor,
  }) : super(key: key);
  final String appBarTitle;
  final List<String> listOfLines;
  final Color topicColor;
  @override
  State<PickUpLinesScreen> createState() => _PickUpLinesScreenState();
}

class _PickUpLinesScreenState extends State<PickUpLinesScreen> {
  final translator = GoogleTranslator();

  late List<bool> isFavoriteList; // Track favorite status for each item
  late List<String?> translatedTextList;
  // Add a variable to track translation button color
  late List<Color> translationButtonColors;
  late bool translating;
  late List<bool> translatingIndexState;

  @override
  void initState() {
    super.initState();
    isFavoriteList = [];
    _initializeFavorites();
    translatedTextList = List.filled(widget.listOfLines.length, null);
    // Initialize button colors
    translationButtonColors =
        List.filled(widget.listOfLines.length, Colors.white); // Initial color
    translating = false;
    translatingIndexState = List.filled(widget.listOfLines.length, false);
  }

  // Initialize favorite status for each item from SharedPreferences
  Future<void> _initializeFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.listOfLines.isNotEmpty) {
      // Check if listOfLines is not empty
      setState(() {
        isFavoriteList = List.generate(
          widget.listOfLines.length,
          (index) => prefs.getBool('${widget.appBarTitle}_item$index') ?? false,
        );
      });
    }
  }

  // Toggle favorite status for an item at a given index
  Future<void> _toggleFavorite(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<bool> updatedFavorites = List.from(isFavoriteList);

    updatedFavorites[index] = !updatedFavorites[index];
    setState(() {
      isFavoriteList = updatedFavorites;
    });

    await prefs.setBool(
        '${widget.appBarTitle}_item$index', updatedFavorites[index]);
  }

  // Translation Function
  Future<void> translateToNepali(int index) async {
    Translation translation =
        await translator.translate(widget.listOfLines[index], to: 'ne');
    setState(() {
      translatedTextList[index] = translation.toString();
      translating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width / 15,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.listOfLines.length,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomLeft,
                    colors: [widget.topicColor, appColor],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          """ "${widget.listOfLines[index]}" """,
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
                            _toggleFavorite(index);
                            if (isFavoriteList.isNotEmpty &&
                                isFavoriteList[index]) {
                              removeStringFromFavorite(
                                  widget.listOfLines[index]);
                            } else {
                              addItemToFavourite(widget.listOfLines[index]);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 5,
                              side: const BorderSide(
                                  color: Colors.black, width: 0.5)),
                          child: Icon(
                            isFavoriteList.isNotEmpty && isFavoriteList[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavoriteList.isNotEmpty &&
                                    isFavoriteList[index]
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        //Elevation button for translation icon

                        ElevatedButton(
                          onPressed: () async {
                            final internetCheck = context.read<InternetBloc>();
                            final currentState = internetCheck.state;
                            if (currentState is InternetGainedState) {
                              setState(() {
                                translatingIndexState[index] = true;
                              });
                              await translateToNepali(index);
                              // Toggle button color
                              setState(() {
                                translationButtonColors[
                                    index] = translationButtonColors[index] ==
                                        widget.topicColor
                                    ? widget
                                        .topicColor // Change to your desired color
                                    : widget.topicColor;
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red.withOpacity(0.9),
                                duration: const Duration(seconds: 2),
                                content: const Text(
                                  "No internet connection...",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ));
                            }
                            //Reset translating status after 2 second
                            Future.delayed(const Duration(milliseconds: 500), () {
                              setState(() {
                                translatingIndexState[index] = false;
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black, backgroundColor: translationButtonColors[index],
                              elevation: 5,
                              side: const BorderSide(
                                  color: Colors.black, width: 0.5)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Conditionally show translate icon based on translating status

                              if (!translatingIndexState[index])
                                const Icon(
                                  Icons.g_translate,
                                  color: Colors.black,
                                ),
                              // Show circular progress indicator while translating
                              if (translatingIndexState[index])
                                const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black,
                                ),
                            ],
                          ),
                        ),
                        //Elevation button for share icon
                        ElevatedButton(
                          onPressed: () async {
                            final internetCheck = context.read<InternetBloc>();
                            final currentState = internetCheck.state;
                            if (currentState is InternetGainedState) {
                              await Share.share(widget.listOfLines[index]);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red.withOpacity(0.9),
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
      ),
    );
  }
}
