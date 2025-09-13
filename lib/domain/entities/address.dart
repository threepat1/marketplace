import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String address;
  final String subDistrict;
  final String district;
  final String province;
  final String postcode;
  final bool isDefaultShipping;

  const Address({
    required this.address,
    required this.subDistrict,
    required this.district,
    required this.province,
    required this.postcode,
    this.isDefaultShipping = false,
  });

  @override
  List<Object> get props => [
        address,
        subDistrict,
        district,
        province,
        postcode,
        isDefaultShipping,
      ];
}

