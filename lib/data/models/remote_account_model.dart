import 'package:flutter_clean_solid/domain/entities/entities.dart';

class RemoteAccountModel extends AccountEntity {
  RemoteAccountModel({required super.token});

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
    return RemoteAccountModel(token: json['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(token: token);
}
