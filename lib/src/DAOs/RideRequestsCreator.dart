import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:our_ride/src/DAOs/UserProfileData.dart';
import 'package:our_ride/src/models/rideshare_model.dart';
import 'package:our_ride/src/models/user_profile.dart';

class RideRequestsCreator {

  static final databaseReference = Firestore.instance;

  static create(Rideshare rideshare, String riderId) async {
    UserProfile riderProfile =  await UserProfileData.fetchUserProfileData(riderId);
    
    Map<String, dynamic> rideRequestMap = {};
    rideRequestMap['driverId'] = rideshare.driverId;
    rideRequestMap['riderId'] = riderId;
    rideRequestMap['riderFirstName'] = riderProfile.firstName;
    rideRequestMap['riderLastName'] = riderProfile.lastName;
    rideRequestMap['facebookId'] = riderProfile.facebookUserId;
    rideRequestMap['profilePic'] = riderProfile.profilePic;
    rideRequestMap['pickUpLocation'] = rideshare.locationPickUp.description;
    rideRequestMap['dropOffLocation'] = rideshare.locationDropOff.description;
    rideRequestMap['rideshareDate'] = rideshare.rideDate.toString();
     rideRequestMap['rideTime'] = rideshare.rideTime.hour.toString() + ':' + rideshare.rideTime.minute.toString();
    rideRequestMap['ridesharePrice'] = rideshare.price;
    rideRequestMap['rideshareRef'] = rideshare.driverId + '-' + rideshare.rideDate.toString().split(' ')[0] + '-' + rideshare.rideTime.hour.toString() + ':' + rideshare.rideTime.minute.toString();


    final snapShot = await databaseReference
      .collection('rideshare-requests')
      .document(rideshare.driverId)
      .get();
    
    if(snapShot == null || !snapShot.exists) {
      databaseReference
        .collection('rideshare-requests')
        .document(rideshare.driverId)
        .setData({
          'requests': [
            rideRequestMap,
          ],
        });
    } else {
      databaseReference
        .collection('rideshare-requests')
        .document(rideshare.driverId)
        .updateData(
          {"requests": FieldValue.arrayUnion([rideRequestMap])},
        );
    }

  }

}