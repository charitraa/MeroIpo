import 'package:equatable/equatable.dart';

/// A saved MeroShare account. The password is NOT held here — it lives in
/// flutter_secure_storage keyed by [id].
class AccountEntity extends Equatable {
  const AccountEntity({
    required this.id,
    required this.nickname,
    required this.dpId,
    required this.username,
    required this.crn,
    required this.boid,
    required this.bankId,
    this.autoApplyEnabled = true,
    this.createdAt,
    this.lastAppliedAt,
  });

  final String id; // UUID — local
  final String nickname; // e.g. "Hari's account"
  final String dpId; // Depository Participant id e.g. "13200"
  final String username; // MeroShare login username
  final String crn; // C-ASBA Registration Number
  final String boid; // 16-digit demat account id
  final String bankId; // Bank account id for ASBA
  final bool autoApplyEnabled;
  final DateTime? createdAt;
  final DateTime? lastAppliedAt;

  AccountEntity copyWith({
    String? nickname,
    String? dpId,
    String? username,
    String? crn,
    String? boid,
    String? bankId,
    bool? autoApplyEnabled,
    DateTime? createdAt,
    DateTime? lastAppliedAt,
  }) {
    return AccountEntity(
      id: id,
      nickname: nickname ?? this.nickname,
      dpId: dpId ?? this.dpId,
      username: username ?? this.username,
      crn: crn ?? this.crn,
      boid: boid ?? this.boid,
      bankId: bankId ?? this.bankId,
      autoApplyEnabled: autoApplyEnabled ?? this.autoApplyEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastAppliedAt: lastAppliedAt ?? this.lastAppliedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nickname,
        dpId,
        username,
        crn,
        boid,
        bankId,
        autoApplyEnabled,
        createdAt,
        lastAppliedAt,
      ];
}
