import 'package:flutter/material.dart';
import 'package:pickup_lines/constraints.dart';
import 'package:pickup_lines/drawer_widget.dart';
import 'package:pickup_lines/pickupLines_page.dart';
import 'package:pickup_lines/topic_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "PickUp Lines",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: appColor,
      ),
      body: ListView.builder(
        itemCount: topicList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, top: 7),
            child: SizedBox(
              height: size.height / 7,
              width: size.width,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickUpLinesScreen(
                                appBarTitle: topicList[index].topicName,
                                listOfLines: topicList[index].listOfLines,
                                topicColor: topicList[index].topicColor,
                              )));
                },
                child: Card(
                  color: topicList[index].topicColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: ListTile(
                      title: Text(
                        topicList[index].topicName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: size.width / 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          shadows: const <Shadow>[
                            Shadow(
                                color: Colors.black, offset: Offset(0.7, 0.1)),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        height: size.height / 5,
                        width: size.width / 5,
                        child: Image.asset(
                          "assets/images/${topicList[index].iconName}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
