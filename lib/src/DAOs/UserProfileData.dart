import '../models/user_profile.dart';
import '../models/review.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileData{

  static final  databaseReference = FirebaseDatabase.instance.reference();

  static Future<List<UserProfile>> fetchProfileDataForUsers(List<String> userIds) async {
    List<UserProfile> userProfiles = [];
    for(String user_id in userIds) {
      Future<UserProfile> profile = await fetchUserProfileData(user_id)
      .then((UserProfile userProfile) {
        userProfiles.add(userProfile);
      });
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
      null,
      facebookUserId,
      reviewList,
    ));      
  }

  static int calculatePoints(bool isDriver, int ridesGiven, int ridesTaken) {
    if(isDriver)
      return ridesGiven * 10;
    else
      return ridesTaken * 10;
  }

  static void openFacebookProfile(String facebookUserId) async {
    String fbProtocolUrl = 'fb://profile/' + facebookUserId;
    String fallbackUrl = 'https://www.facebook.com/profile?id=' + facebookUserId;
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}