//Function to read data from list of shared preference
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getAllItems() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Set<String> keys = prefs.getKeys();
  List<String> allItems = [];
  for (String key in keys) {
    dynamic value = prefs.get(key);
    if (value is List<String>) {
      allItems.addAll(value);
    }
  }
  return allItems;
}

//Adding item in my_favourite
addItemToFavourite(String item) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteList = prefs.getStringList(item) ?? [];
  favoriteList.add(item);
  await prefs.setStringList(item, favoriteList);
}

//Remove a string from my_favourite
removeStringFromFavorite(String item) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> favoriteList = prefs.getStringList(item) ?? [];
 
  favoriteList.remove(item);
  await prefs.setStringList(item, favoriteList);
}
