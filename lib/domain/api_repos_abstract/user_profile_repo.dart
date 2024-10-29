import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_repo/base.dart';

abstract class UserProfileRepo extends Base {
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserProfileData(
      String userId);
  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserPersonalData(
      String userId);
}
