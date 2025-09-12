import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String? birthday;
  final String? email;
  final String? gender;
  final String? address;
  final String? subDistrict;
  final String? district;
  final String? province;
  final String? phoneNumber;
  final bool complete;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    this.email,
    this.birthday,
    this.gender,
    this.address,
    this.subDistrict,
    this.district,
    this.province,
    this.phoneNumber,
    this.complete = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
        birthday,
        gender,
        address,
        subDistrict,
        district,
        province,
        phoneNumber,
        complete,
      ];
}
