import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_management/auth/profile/bloc/profile_event.dart';
import 'package:receipt_management/auth/profile/bloc/profile_state.dart';
import 'package:receipt_management/auth/profile/repository/profile_repository.dart';
import 'package:receipt_management/config/shared_preferences.dart';

final _preference = SharedPreferenceStorage();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository = ProfileRepository();
  ProfileBloc() : super(ProfileUnloaded()) {
    on<ProfileUnload>(_onProfileUnload);
    on<ProfileLogout>(_onProfileLogout);
    on<ProfileLoad>(_onProfileLoad);
    on<ProfileEdit>(_onProfileEdit);
    on<ProfileSave>(_onProfileSave);
    on<ProfileDelete>(_onProfileDelete);
  }

  @override
  Future<void> close() {
    // dispose
    emit(ProfileUnloaded());
    return super.close();
  }

  Future<void> _onProfileUnload(
      ProfileUnload event, Emitter<ProfileState> emit) async {
    emit(ProfileUnloaded());
  }

  Future<void> _onProfileDelete(
      ProfileDelete event, Emitter<ProfileState> emit) async {
    await _preference.removeSession();
    emit(ProfileUnloaded());
    emit(ProfileLoggedOut());
  }

  Future<void> _onProfileLogout(
      ProfileLogout event, Emitter<ProfileState> emit) async {
    await _preference.removeSession();
    emit(ProfileUnloaded());
    emit(ProfileLoggedOut());
  }

  Future<void> _onProfileEdit(
      ProfileEdit event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepository.profileRoute();
      emit(ProfileEditing(
        // id: profile.id,
        firstName: profile.firstName,
        lastName: profile.lastName,
        email: profile.email,

        profileImage: profile.profilePicture,
      ));
    } catch (e) {
      emit(ProfileFailed(errorMsg: "Edition failed"));
    }
  }

  Future<void> _onProfileLoad(
      ProfileLoad event, Emitter<ProfileState> emit) async {
    final profile = await profileRepository.profileRoute();

    try {
      emit(ProfileLoaded(
        id: profile.id,
        firstName: profile.firstName,
        lastName: profile.lastName,
        email: profile.email,
        profileImage: profile.profilePicture,
        receiptData: profile.receiptCount,
        requestsData: profile.requestCount,
        daysWithUs: profile.daysWithUs,
      ));
    } catch (e) {
      emit(ProfileFailed(errorMsg: "Edition failed"));
    }
  }

  Future<void> _onProfileSave(
      ProfileSave event, Emitter<ProfileState> emit) async {
    try {
      final _res = await profileRepository.profileUpdate(
        event.profileImage,
        event.firstName,
        event.lastName,
        event.email,
        event.oldPassword,
        event.password,
      );
      emit(ProfileUnloaded());
    } catch (e) {
      emit(ProfileFailed(errorMsg: "Edition failed"));
    }
  }
}
