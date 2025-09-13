import 'package:equatable/equatable.dart';
import 'address.dart';
import 'bidded_product.dart';
import 'saved_product.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String username;
  final String? birthday;
  final String? email;
  final String? gender;
  final String? address;
  final String? subDistrict;
  final String? district;
  final String? province;
  final String? phoneNumber;
  final bool complete;
  final List<SavedProduct> savedProducts;
  final List<BiddedProduct> biddedProducts;
  final List<Address> addresses;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    this.email,
    this.birthday,
    this.gender,
    this.address,
    this.subDistrict,
    this.district,
    this.province,
    this.phoneNumber,
    this.complete = false,
    this.savedProducts = const [],
    this.biddedProducts = const [],
    this.addresses = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
        username,
        birthday,
        gender,
        address,
        subDistrict,
        district,
        province,
        phoneNumber,
        complete,
        savedProducts,
        biddedProducts,
        addresses
      ];
}
