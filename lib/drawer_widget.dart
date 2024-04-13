import 'package:flutter/material.dart';
import 'package:pickup_lines/SharedPreference_file.dart';
import 'package:pickup_lines/constraints.dart';
import 'package:pickup_lines/favorite_lines.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List<String>? favoriteItems;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  //Loading favorite items
  Future<void> loadItems() async {
    List<String> items = await getAllItems();
    setState(() {
      favoriteItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: [
          Card(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width / 4,
                    height: size.width / 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset("assets/images/logo.png", fit: BoxFit.fill,)),
                  ),
                  const Text(
                    "Pickup Lines",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("Favorites"),
            leading: const Icon(Icons.favorite),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoriteLinesScreen(
                            favoriteItemsList:
                                favoriteItems != null ? favoriteItems! : [],
                          )));
            },
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Check For Update"),
            leading: const Icon(Icons.update),
            onTap: () async {
              if (await canLaunch(appLinkFromPlayStore)) {
                await launch(appLinkFromPlayStore, universalLinksOnly: true);
              } else {
                throw "";
              }
            },
          ),
          ListTile(
            title: const Text("Share"),
            leading: const Icon(Icons.share),
            onTap: () async {
              await Share.share(appLinkFromPlayStore);
            },
          ),
        ],
      ),
    );
  }
}
