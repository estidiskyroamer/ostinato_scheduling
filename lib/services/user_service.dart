import 'package:dio/dio.dart';
import 'package:ostinato/common/components/components.dart';
import 'package:ostinato/models/user.dart';
import 'package:ostinato/services/config.dart';

class UserService {
  Future<UserDetail?> getUserDetail(String id) async {
    UserDetail? user;
    try {
      Response response = await ServiceConfig().dio.get('/users/show/$id');
      user = UserDetail.fromJson(response.data);
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
    }
    return user;
  }

  Future<User?> createUser(User user) async {
    User? newUser;
    Map<String, dynamic> params = user.toJson();
    try {
      Response response =
          await ServiceConfig().dio.post('/users', data: params);
      if (response.statusCode == 200) {
        UserDetail newUserDetail = UserDetail.fromJson(response.data);
        newUser = newUserDetail.data;
      }
      return newUser;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return newUser;
    }
  }

  Future<User?> updateUser(User user) async {
    User? updatedUser;
    Map<String, dynamic> params = user.toJson();
    try {
      Response response =
          await ServiceConfig().dio.put('/users/user/${user.id}', data: params);
      if (response.statusCode == 200) {
        UserDetail updatedUserDetail = UserDetail.fromJson(response.data);
        updatedUser = updatedUserDetail.data;
      }
      toastNotification(response.data['message']);
      return updatedUser;
    } on DioException catch (e) {
      toastNotification(e.response!.data['errors'][0]);
      return updatedUser;
    }
  }
}
