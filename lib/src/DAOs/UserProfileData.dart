import 'package:our_ride/src/models/car.dart';
import 'package:our_ride/src/models/payment_method.dart';
import '../models/user_profile.dart';
import '../models/review.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileData{

  static final  databaseReference = FirebaseDatabase.instance.reference();

  static Future<List<UserProfile>> fetchProfileDataForUsers(List<String> userIds) async {
    List<UserProfile> userProfiles = [];
    for(String user_id in userIds) {
      UserProfile userProfile = await fetchUserProfileData(user_id);
      userProfiles.add(userProfile);
    }

    return Future.value(userProfiles);
  }

  static Future<Map<String, UserProfile>> fetchProfileDataForUsersMap(List<String> userIds) async {
    Map<String, UserProfile> userProfiles =  {};
    for(String user_id in userIds) {
      UserProfile userProfile = await fetchUserProfileData(user_id);
      userProfiles[user_id] = userProfile;
    }
    return Future.value(userProfiles);
  }

  
  static Future<UserProfile> fetchUserProfileData(String user_id) async {
    var data;
    await databaseReference.child(user_id).once().then((DataSnapshot snapshot) {
      data = snapshot.value;
    });
    String email = data['email'].toString();
    String password = data['password'].toString();
    String firstName = data['firstName'].toString();
    String lastName = data['lastName'].toString();
    bool isMale = data['isMale'];
    String driverLicenseNumber = data['driverLicenseNumber'].toString();
    String city = data['city'].toString();
    int ridesGiven = data['ridesGiven'];
    int ridesTaken = data['ridesTaken'];
    String aboutMe = data['aboutMe'].toString();
    String program = data['program'].toString();
    String university = data['university'].toString();
    String profilePic = data['profilePic'].toString();
    String facebookUserId = data['facebookUserId'];
    int numberOfReviews = data['reviews'] != null ? (data['reviews'] as List).length : 0;
    List<Review> reviewList = [];
    int index = 0;
    while(index < numberOfReviews) {
      reviewList.add(
        new Review(
          data['reviews'][index]['rating'],
          data['reviews'][index]['reviewer'],
          data['reviews'][index]['reviewContent'])
      );
      index++;
    }
    PaymentMethod paymentMethod = PaymentMethod.fromDetails(
      data['paymentMethod']['cardHolderName'],
      data['paymentMethod']['cardNumber'],
      data['paymentMethod']['expireDate'],
      data['paymentMethod']['cvv']
    );

    List<Car> userVehicles = [];
    int numberOfUserVehicles = data['userVehicles'] != null ? (data['userVehicles'] as List).length: 0;
    for(int i = 0; i < numberOfUserVehicles; i++) {
      userVehicles.add(
        new Car.fromCarDetails(
          data['userVehicles'][i]['model'],
          data['userVehicles'][i]['make'],
          data['userVehicles'][i]['year'],
          data['userVehicles'][i]['licensePlate'],
        )
      );
    }

    return Future.value(new UserProfile.fromDetails(
      email,
      password,
      firstName,
      lastName,
      isMale,
      driverLicenseNumber,
      city,
      calculatePoints(driverLicenseNumber != null, ridesGiven, ridesTaken),
      ridesGiven,
      ridesTaken,
      aboutMe,
      program,
      university,
      profilePic,
      facebookUserId,
      reviewList,
      paymentMethod,
      userVehicles,
    ));      
  }

  static int calculatePoints(bool isDriver, int ridesGiven, int ridesTaken) {
    if(isDriver)
      return ridesGiven * 10;
    else
      return ridesTaken * 10;
  }

  static void openFacebookProfile(String facebookUserId) async {
    String fbProtocolUrl = 'https://www.facebook.com/profile?id=' + facebookUserId;
    await launch(fbProtocolUrl, forceSafariVC: false);
  } 
}