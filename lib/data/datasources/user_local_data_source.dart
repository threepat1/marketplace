import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:marketplace/domain/entities/user.dart';
import 'package:marketplace/domain/entities/address.dart';
import 'package:marketplace/domain/entities/bidded_product.dart';
import 'package:marketplace/domain/entities/saved_product.dart';

abstract class UserLocalDataSource {
  Future<User> loadUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<User> loadUser() async {
    final jsonString = await rootBundle.loadString('assets/user.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final username = jsonMap['username']?.toString() ?? '';

    return User(
      id: jsonMap['id']?.toString() ?? '',
      name: jsonMap['name']?.toString() ?? username,
      surname: jsonMap['surname']?.toString() ?? '',
      username: username,
      email: jsonMap['email']?.toString(),
      birthday: jsonMap['birthday']?.toString(),
      gender: jsonMap['gender']?.toString(),
      address: jsonMap['address']?.toString(),
      subDistrict: jsonMap['subDistrict']?.toString(),
      district: jsonMap['district']?.toString(),
      province: jsonMap['province']?.toString(),
      phoneNumber: jsonMap['phoneNumber']?.toString(),
      complete: jsonMap['complete'] as bool? ?? true,
      savedProducts: (jsonMap['savedProducts'] as List<dynamic>? ?? [])
          .map(
            (e) => SavedProduct(
              productId: e['productId']?.toString() ?? '',
              currentBid: (e['price'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList(),
      biddedProducts: (jsonMap['biddedProducts'] as List<dynamic>? ?? [])
          .map(
            (e) => BiddedProduct(
              productId: e['productId']?.toString() ?? '',
              currentBid: (e['currentBid'] as num?)?.toDouble() ?? 0,
              yourBid: (e['yourBid'] as num?)?.toDouble() ?? 0,
            ),
          )
          .toList(),
      addresses: (jsonMap['addresses'] as List<dynamic>? ?? [])
          .map(
            (e) => Address(
              address: e['street']?.toString() ?? '',
              subDistrict: e['subDistrict']?.toString() ?? '',
              district: e['district']?.toString() ?? '',
              province: e['province']?.toString() ?? '',
              postcode: e['postcode']?.toString() ?? '',
              isDefaultShipping: e['isDefaultShipping'] as bool? ?? false,
            ),
          )
          .toList(),
    );
  }
}

