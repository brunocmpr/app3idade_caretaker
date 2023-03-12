import 'package:app3idade_caretaker/models/app_user.dart';
import 'package:app3idade_caretaker/repository/app_user_repository.dart';

class AppUserService {
  AppUserRepository appUserRepository = AppUserRepository();

  Future<AppUser> findById(int id) async {
    return appUserRepository.deleteById(id);
  }

  Future<AppUser> createAppUser(AppUser user) async {
    return appUserRepository.create(user);
  }

  Future<AppUser> createUpdateUser(AppUser user) async {
    return appUserRepository.update(user);
  }

  Future<AppUser> deleteUserById(int id) async {
    return appUserRepository.deleteById(id);
  }
}
