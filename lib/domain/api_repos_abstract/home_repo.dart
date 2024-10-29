import 'package:cloud_firestore/cloud_firestore.dart';

import '../base_repo/base.dart';

abstract class HomeRepo extends Base {
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUsersCreations();
}
