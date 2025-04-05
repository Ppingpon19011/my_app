import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_app/repositories/cattle_repository.dart';
import 'package:my_app/user_repository.dart';
//import 'package:user_repository/user_repository.dart';

part 'cattle_event.dart';
part 'cattle_state.dart';

class CattleBloc extends Bloc<CattleEvent, CattleState> {
  final CattleRepository _cattleRepository;
  final UserRepository _userRepository;

  CattleBloc(this._cattleRepository, this._userRepository) : super(CattleInitial()) {
    on<LoadCattleProfiles>(_onLoadCattleProfiles);
    on<LoadCurrentUserCattleProfiles>(_onLoadCurrentUserCattleProfiles);
    on<SearchCattleProfiles>(_onSearchCattleProfiles);
    on<AddCattleProfile>(_onAddCattleProfile);
    on<UpdateCattleProfile>(_onUpdateCattleProfile);
    on<DeleteCattleProfile>(_onDeleteCattleProfile);
  }

  Future<void> _onLoadCattleProfiles(
    LoadCattleProfiles event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final profiles = await _cattleRepository.getAllCattleProfiles();
      emit(CattleLoaded(profiles));
    } catch (e) {
      emit(CattleError('ไม่สามารถโหลดข้อมูลโคได้: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCurrentUserCattleProfiles(
    LoadCurrentUserCattleProfiles event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final currentUser = _userRepository.currentUser;
      if (currentUser != MyUser.empty) {
        final profiles = await _cattleRepository.getCurrentUserCattleProfiles(currentUser.id);
        emit(CattleLoaded(profiles));
      } else {
        emit(CattleError('ไม่ได้ล็อกอิน'));
      }
    } catch (e) {
      emit(CattleError('ไม่สามารถโหลดข้อมูลโคได้: ${e.toString()}'));
    }
  }

  Future<void> _onSearchCattleProfiles(
    SearchCattleProfiles event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final currentUser = _userRepository.currentUser;
      List<Map<String, dynamic>> profiles;
      
      if (currentUser != MyUser.empty) {
        // ค้นหาเฉพาะโคของผู้ใช้ที่ล็อกอินเท่านั้น
        profiles = await _cattleRepository.searchCattleProfilesByUser(event.query, currentUser.id);
      } else {
        profiles = await _cattleRepository.searchCattleProfiles(event.query);
      }
      
      emit(CattleLoaded(profiles));
    } catch (e) {
      emit(CattleError('ไม่สามารถค้นหาข้อมูลโคได้: ${e.toString()}'));
    }
  }

  Future<void> _onAddCattleProfile(
    AddCattleProfile event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final currentUser = _userRepository.currentUser;
      if (currentUser != MyUser.empty) {
        final id = await _cattleRepository.addCattleProfile(event.profileData, currentUser.id);
        emit(CattleAdded(id));
        
        // โหลดข้อมูลทั้งหมดอีกครั้งหลังจากการเพิ่ม
        final profiles = await _cattleRepository.getCurrentUserCattleProfiles(currentUser.id);
        emit(CattleLoaded(profiles));
      } else {
        emit(CattleError('ไม่ได้ล็อกอิน ไม่สามารถเพิ่มข้อมูลโคได้'));
      }
    } catch (e) {
      emit(CattleError('ไม่สามารถเพิ่มข้อมูลโคได้: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCattleProfile(
    UpdateCattleProfile event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final currentUser = _userRepository.currentUser;
      
      // เพิ่มการตรวจสอบว่าโคเป็นของผู้ใช้ที่ล็อกอินหรือไม่
      final cattleProfile = await _cattleRepository.getCattleProfileById(event.profileData['id']);
      if (cattleProfile != null && cattleProfile['user_id'] == currentUser.id) {
        final count = await _cattleRepository.updateCattleProfile(event.profileData);
        emit(CattleUpdated(count));
        
        // โหลดข้อมูลทั้งหมดอีกครั้งหลังจากการอัปเดต
        final profiles = await _cattleRepository.getCurrentUserCattleProfiles(currentUser.id);
        emit(CattleLoaded(profiles));
      } else {
        emit(CattleError('ไม่มีสิทธิ์แก้ไขข้อมูลโคนี้'));
      }
    } catch (e) {
      emit(CattleError('ไม่สามารถอัปเดตข้อมูลโคได้: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCattleProfile(
    DeleteCattleProfile event,
    Emitter<CattleState> emit,
  ) async {
    emit(CattleLoading());
    try {
      final currentUser = _userRepository.currentUser;
      
      // เพิ่มการตรวจสอบว่าโคเป็นของผู้ใช้ที่ล็อกอินหรือไม่
      final cattleProfile = await _cattleRepository.getCattleProfileById(event.id);
      if (cattleProfile != null && cattleProfile['user_id'] == currentUser.id) {
        final count = await _cattleRepository.deleteCattleProfile(event.id);
        emit(CattleDeleted(count));
        
        // โหลดข้อมูลทั้งหมดอีกครั้งหลังจากการลบ
        final profiles = await _cattleRepository.getCurrentUserCattleProfiles(currentUser.id);
        emit(CattleLoaded(profiles));
      } else {
        emit(CattleError('ไม่มีสิทธิ์ลบข้อมูลโคนี้'));
      }
    } catch (e) {
      emit(CattleError('ไม่สามารถลบข้อมูลโคได้: ${e.toString()}'));
    }
  }
}