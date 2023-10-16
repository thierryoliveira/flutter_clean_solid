import 'package:flutter_clean_solid/data/http/http.dart';
import 'package:flutter_clean_solid/domain/entities/entities.dart';

class RemoteAccountModel extends AccountEntity {
  RemoteAccountModel({required super.token});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('accessToken')) throw HttpError.invalidData;
    return RemoteAccountModel(token: json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(token: token);
}
