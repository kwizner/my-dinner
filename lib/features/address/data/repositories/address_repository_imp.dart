import 'package:either_option/either_option.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'package:my_dinner/core/services/failures.dart';
import 'package:my_dinner/features/address/data/datasources/address_api.dart';
import 'package:my_dinner/features/address/domain/models/address.dart';
import 'package:my_dinner/features/address/domain/repositories/address_repository.dart';
import 'package:my_dinner/features/address/domain/usecases/add_address.dart';
import 'package:my_dinner/features/address/domain/usecases/update_address.dart';

@RegisterAs(AddressRepository)
@singleton
class AddressRepositoryImp extends AddressRepository {
  final AddressApi addressApi;

  AddressRepositoryImp(this.addressApi);

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      return Right(await addressApi.getAddresses());
    } catch (e) {
      Logger().e(e);
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(AddAddressParams params) async {
    try {
      return Right(await addressApi.addAddress(params.address));
    } catch (e) {
      Logger().e(e);
      return Left(ApiFailure());
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(
      UpdateAddressParams params) async {
    try {
      return Right(await addressApi.updateAddress(params.address));
    } catch (e) {
      Logger().e(e);
      return Left(ApiFailure());
    }
  }
}