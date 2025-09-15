import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:dartz/dartz.dart';

abstract class Repo {
  Future<Either<Failure, T>> calling<T>(
      {BaseEnity? entity, required dynamic db});
}
