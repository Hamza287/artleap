// import 'package:photoroomapp/domain/data_classes/reqres.dart';

// import '../domain/api_services/api_response.dart';
// import '../domain/base_repo/base_repo.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../shared/console.dart';

// final reqresProvider =
//     NotifierProvider<ReqResProvider, ReqResPractice>(ReqResProvider.new);

// class ReqResProvider extends Notifier<ReqResPractice> with BaseRepo {
//   @override
//   ReqResPractice build() => ReqResPractice(
//         reqresData: ApiResponse.loading(),
//       );
//   getReqresUsers() async {
//     ApiResponse userRes =
//         await reqresRepo.getUserData(enableLocalPersistence: false);
//     state = state.copyWith(reqresData: userRes);
//     console('PROVIDERR : ${userRes.status}');
//     console('llllllllllllllllllllllllllllllllllllllllllllll');
//   }
// }
