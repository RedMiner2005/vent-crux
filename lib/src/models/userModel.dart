import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';


/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    this.id,
    required this.phone,
    this.inbox
  });

  final String? id;
  final String phone;
  final List<dynamic>? inbox;

  static const empty = UserModel(id: '', phone: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [phone, id];

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(id: json["id"], phone: json["email"] ?? "", inbox: json["inbox"] ?? []);
  }

  UserModel copyWith({id, phone, name, inbox}) {
    return UserModel(id: id ?? this.id, phone: phone ?? this.phone, inbox: inbox ?? this.inbox);
  }

  Map<String, dynamic> toJSON({bool isAuth=true}) {
    if (id == null) {
      List<int> bytes = utf8.encode('message');
      String hash = sha256.convert(bytes).toString();
      return (isAuth) ? {"id": hash, "phone": phone} : {"id": hash, "phone": phone, "inbox": inbox};
    }
    return (isAuth) ? {"id": id, "phone": phone} : {"id": id, "phone": phone, "inbox": inbox};
  }
}