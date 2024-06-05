import 'package:equatable/equatable.dart';


/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    required this.id,
    this.phone,
    this.name,
    this.inbox
  });

  final String id;
  final String? phone;
  final String? name;
  final List<dynamic>? inbox;

  static const empty = UserModel(id: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [phone, id, name];

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(id: json["id"], phone: json["email"] ?? "", name: json["name"] ?? "", inbox: json["inbox"] ?? []);
  }

  UserModel copyWith({id, phone, name, inbox}) {
    return UserModel(id: id ?? this.id, phone: phone ?? this.phone, name: name ?? this.name, inbox: inbox ?? this.inbox);
  }

  Map<String, dynamic> toJSON({bool isAuth=true}) {
    return (isAuth) ? {"id": id, "phone": phone, "name": name} : {"id": id, "phone": phone, "name": name, "inbox": inbox};
  }

  bool isValidProfile() {
    return name != "" && name != null;
  }
}