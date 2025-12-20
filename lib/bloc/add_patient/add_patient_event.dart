part of 'add_patient_bloc.dart';

abstract class AddPatientEvent extends Equatable {
  const AddPatientEvent();

  @override
  List<Object?> get props => [];
}

class FullNameChangeEvent extends AddPatientEvent {
  final String name;
  const FullNameChangeEvent({required this.name});
  @override
  List<Object> get props => [name];
}

class EmailChangeEvent extends AddPatientEvent {
  final String email;
  const EmailChangeEvent({required this.email});
  @override
  List<Object> get props => [email];
}

class BackgroundChangeEvent extends AddPatientEvent {
  final String background;
  const BackgroundChangeEvent({required this.background});
  @override
  List<Object> get props => [background];
}

class MediHistChangeEvent extends AddPatientEvent {
  final String mediHist;
  const MediHistChangeEvent({required this.mediHist});
  @override
  List<Object> get props => [mediHist];
}

class FamilyHistChangeEvent extends AddPatientEvent {
  final String familyHist;
  const FamilyHistChangeEvent({required this.familyHist});
  @override
  List<Object> get props => [familyHist];
}

class SocialHistChangeEvent extends AddPatientEvent {
  final String socialHist;
  const SocialHistChangeEvent({required this.socialHist});
  @override
  List<Object> get props => [socialHist];
}

class PrevHistChangeEvent extends AddPatientEvent {
  final String prevHist;
  const PrevHistChangeEvent({required this.prevHist});
  @override
  List<Object> get props => [prevHist];
}

class PronounChangeEvent extends AddPatientEvent {
  final String pronoun;
  const PronounChangeEvent({required this.pronoun});
  @override
  List<Object> get props => [pronoun];
}

class AddPatientsButtonPressed extends AddPatientEvent {}

class ClearFieldAfterSuccess extends AddPatientEvent {}
