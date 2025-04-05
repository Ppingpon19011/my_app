part of 'cattle_bloc.dart';

abstract class CattleState extends Equatable {
  const CattleState();
  
  @override
  List<Object> get props => [];
}

class CattleInitial extends CattleState {}

class CattleLoading extends CattleState {}

class CattleLoaded extends CattleState {
  final List<Map<String, dynamic>> profiles;

  const CattleLoaded(this.profiles);

  @override
  List<Object> get props => [profiles];
}

class CattleError extends CattleState {
  final String message;

  const CattleError(this.message);

  @override
  List<Object> get props => [message];
}

class CattleAdded extends CattleState {
  final int id;

  const CattleAdded(this.id);

  @override
  List<Object> get props => [id];
}

class CattleUpdated extends CattleState {
  final int count;

  const CattleUpdated(this.count);

  @override
  List<Object> get props => [count];
}

class CattleDeleted extends CattleState {
  final int count;

  const CattleDeleted(this.count);

  @override
  List<Object> get props => [count];
}