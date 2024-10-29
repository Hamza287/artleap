import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoroomapp/domain/api_repos_abstract/user_profile_repo.dart';

class UserProfileImpl extends UserProfileRepo {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserProfileData(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('usersProfileData').doc(userId).get();
      return documentSnapshot;
    } catch (e) {
      print('Error fetching images: $e');
      return null; // Handle this in the calling function
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserPersonalData(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await firestore.collection('users').doc(userId).get();
      return documentSnapshot;
    } catch (e) {
      print('Error fetching images: $e');
      return null; // Handle this in the calling function
    }
  }
}
