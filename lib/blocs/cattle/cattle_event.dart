part of 'cattle_bloc.dart';

abstract class CattleEvent extends Equatable {
  const CattleEvent();

  @override
  List<Object> get props => [];
}

class LoadCattleProfiles extends CattleEvent {}

class LoadCurrentUserCattleProfiles extends CattleEvent {}

class SearchCattleProfiles extends CattleEvent {
  final String query;

  const SearchCattleProfiles(this.query);

  @override
  List<Object> get props => [query];
}

class AddCattleProfile extends CattleEvent {
  final Map<String, dynamic> profileData;

  const AddCattleProfile(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class UpdateCattleProfile extends CattleEvent {
  final Map<String, dynamic> profileData;

  const UpdateCattleProfile(this.profileData);

  @override
  List<Object> get props => [profileData];
}

class DeleteCattleProfile extends CattleEvent {
  final int id;

  const DeleteCattleProfile(this.id);

  @override
  List<Object> get props => [id];
}