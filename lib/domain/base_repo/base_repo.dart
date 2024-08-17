import 'package:photoroomapp/domain/api_repos_abstract/generate_image_repo.dart';
import 'package:photoroomapp/domain/api_repos_abstract/img2img_repo.dart';
import 'package:photoroomapp/domain/api_repos_abstract/reqres_repo.dart';
import 'package:photoroomapp/domain/api_repos_impl/generate_image_repo_impl.dart';
import 'package:photoroomapp/domain/api_repos_impl/img2img_repo_impl.dart';
import 'package:photoroomapp/domain/api_repos_impl/reqres_repo_impl.dart';

import '../api_repos_abstract/dummy_repo.dart';
import '../api_repos_impl/dummy_repo_impl.dart';

mixin BaseRepo {
  // final DummyRepo _dummyRepo = DummyRepoImpl();
  // DummyRepo get dummyRepo => _dummyRepo;
  final ReqResRepo _reqresRepo = ReqResRepoImpl();
  ReqResRepo get reqresRepo => _reqresRepo;
  final GenerateImageRepo _generateImageRepo = GenerateImageImpl();
  GenerateImageRepo get generateImageRepo => _generateImageRepo;
  final GenerateImg2ImgRepo _generateImgToImgRepo = GenerateImg2ImgImpl();
  GenerateImg2ImgRepo get generateImgToImgRepo => _generateImgToImgRepo;
}
