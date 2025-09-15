import 'package:adary/features/adary/data/datasources/db.dart';
import 'package:adary/features/adary/domain/repositories/repo.dart';

abstract class BaseUseCase {
  final Repo repo;
  final Db db;

  BaseUseCase({required this.repo, required this.db});
}
