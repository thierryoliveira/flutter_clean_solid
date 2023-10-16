class AccountEntity {
  final String token;

  AccountEntity({required this.token});

  factory AccountEntity.fromJson(Map<String, dynamic> json) {
    return AccountEntity(token: json['accessToken']);
  }
}
