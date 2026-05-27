import 'package:equatable/equatable.dart';

import '../../../../shared/enums/ipo_type.dart';

/// An IPO/offering as listed by MeroShare.
class IpoEntity extends Equatable {
  const IpoEntity({
    required this.companyShareId,
    required this.companyName,
    required this.shareTypeName,
    required this.openDate,
    required this.closeDate,
    this.minUnit = 10,
    this.maxUnit = 0,
    this.isOpen = true,
    this.scrip,
  });

  final String companyShareId;
  final String companyName;
  final String shareTypeName; // "Ordinary Shares", "Debenture", etc.
  final DateTime openDate;
  final DateTime closeDate;
  final int minUnit;
  final int maxUnit;
  final bool isOpen;
  final String? scrip; // stock symbol, when provided

  IpoType get type => IpoType.fromShareTypeName(shareTypeName);

  @override
  List<Object?> get props => [
        companyShareId,
        companyName,
        shareTypeName,
        openDate,
        closeDate,
        minUnit,
        maxUnit,
        isOpen,
        scrip,
      ];
}
