import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapsHandler{
  //PLACES API
  static Future<List> fetchLocationSuggestions(String prefixText) async{
    const kGoogleAPIKey = "AIzaSyCoasYE-PQfb6PBIVR8d4M9vxx53pNiNos";
    String vettedPrefix = prefixText.trim().replaceAll(" ", "+");

    const String base = "https://maps.googleapis.com/maps/api/place/autocomplete/json?";
    String params = "input=$vettedPrefix&key=$kGoogleAPIKey&language=en";
    final resp = await http.get(base+params);
    
    if (resp.statusCode == 200) {
      return loadSuggestions(json.decode(resp.body));
    } else {
      return [];
    }
  }

  static List<Map> loadSuggestions(dynamic results){
    List<Map> suggestions = new List<Map>();
    int suggestionInt = 10;
    for(var prediction in results['predictions']){
      suggestions.add({
        'description':prediction['description'],
        'id':prediction['place_id'],
      });
      if(--suggestionInt == 0) break;
    }
    return suggestions;
  }

  //PLACES API
  static Future<List> fetchLatLongForPlaceID(String placeID) async{
    const kGoogleAPIKey = "AIzaSyCoasYE-PQfb6PBIVR8d4M9vxx53pNiNos";
    String vettedPlaceID = placeID.trim();

    const String base = "https://maps.googleapis.com/maps/api/place/details/json?";
    String params = "place_id=$vettedPlaceID&fields=geometry&key=$kGoogleAPIKey";
    final resp = await http.get(base+params);
    
    if (resp.statusCode == 200) {
      return loadLatLong(json.decode(resp.body));
    } else {
      return ["", ""];
    }
  }

  static List<double> loadLatLong(dynamic results){
    return [double.parse(results['result']['geometry']['location']["lat"]), double.parse(results['result']['geometry']['location']["lng"])];
  }
}