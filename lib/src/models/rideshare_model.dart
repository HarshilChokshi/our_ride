class RideshareModel {
  String uid;
  String driver; // 
  List<String> riders;
  String pickup;
  String dropoff;
  String time;
  String date;
  int price;
  
  RideshareModel({
      this.uid, 
      this.driver,
      this.riders, 
      this.pickup,
      this.dropoff,
      this.time,
      this.date,
      this.price,
    });
}