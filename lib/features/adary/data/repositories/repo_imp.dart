import 'package:adary/core/errors/failure.dart';
import 'package:adary/core/utils/calling.dart';
import 'package:adary/features/adary/data/datasources/db.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/repositories/repo.dart';
import 'package:dartz/dartz.dart';

class RepoImp implements Repo {
  final Calling call;

  RepoImp({required this.call});
  @override
  Future<Either<Failure, T>> calling<T>(
          {dynamic? entity, required dynamic db}) =>
      call(db, entity);
}
