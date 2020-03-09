class Location {
  String description;
  String placeId;
  double lat;
  double long;

  Location();

  Location.fromDetails(this.description, this.placeId, this.lat, this.long);

    toJson() {
    return {
      'description': description,
      'placeId': placeId,
      'lat': lat,
      'long': long,
    };
  }
}