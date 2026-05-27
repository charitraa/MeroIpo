/// Category of share offering on MeroShare.
enum IpoType {
  ordinary,
  debenture,
  mutualFund,
  rightShare,
  unknown;

  String get label => switch (this) {
        IpoType.ordinary => 'Ordinary shares',
        IpoType.debenture => 'Debenture',
        IpoType.mutualFund => 'Mutual fund',
        IpoType.rightShare => 'Right share',
        IpoType.unknown => 'Other',
      };

  /// Best-effort mapping from MeroShare's `shareTypeName` string.
  static IpoType fromShareTypeName(String? raw) {
    final v = (raw ?? '').toLowerCase();
    if (v.contains('debenture')) return IpoType.debenture;
    if (v.contains('mutual')) return IpoType.mutualFund;
    if (v.contains('right')) return IpoType.rightShare;
    if (v.contains('ordinary') || v.contains('ipo')) return IpoType.ordinary;
    return IpoType.unknown;
  }
}
