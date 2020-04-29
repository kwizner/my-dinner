import 'package:either_option/either_option.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dinner/core/services/failures.dart';
import 'package:my_dinner/core/services/use_case.dart';
import 'package:my_dinner/features/my_diet/domain/models/diet_order.dart';
import 'package:my_dinner/features/my_diet/domain/repositories/my_diet_repository.dart';

@singleton
class OrderDiet extends UseCase<DietOrder, OrderDietParams> {
  final MyDietRepository myDietRepository;

  OrderDiet(this.myDietRepository);

  @override
  Future<Either<Failure, DietOrder>> call(params) async {
    return await myDietRepository.orderDiet(params.day);
  }
}

class OrderDietParams extends Equatable {
  final DateTime day;

  OrderDietParams(this.day);

  @override
  List<Object> get props => [day];
}
