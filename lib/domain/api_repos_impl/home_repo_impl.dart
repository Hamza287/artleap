import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoroomapp/domain/api_repos_abstract/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUsersCreations() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore
          .collection('CommunityCreations')
          .doc("usersCreations")
          .get();
      return documentSnapshot;
    } catch (e) {
      print('Error fetching images: $e');
      return null; // Handle this in the calling function
    }
  }
}
