// ignore_for_file: non_constant_identifier_names

import 'package:gw_kiosk/data_store.dart';

final class OnboardingStore extends DataStore {
  var chocoInstalled = false;
  var choco_firefox = false;
  var choco_adobereader = false;
  var choco_vlc = false;
  var choco_libreoffice = false;

  var updatePackageInstalled = false;
  var updatesStarted = false;
  var updateIterations = 0;
  var updatesComplete = false;

  var uacEnabled = false;

  var cleanedUp = false;

  OnboardingStore.creator() : super('phase');

  OnboardingStore.empty() : super('phase');

  @override
  void fromMap(Map<String, dynamic> map) {
    chocoInstalled = map['chocoInstalled'] ?? false;
    choco_firefox = map['choco_firefox'] ?? false;
    choco_adobereader = map['choco_adobereader'] ?? false;
    choco_vlc = map['choco_vlc'] ?? false;
    choco_libreoffice = map['choco_libreoffice'] ?? false;

    updatePackageInstalled = map['updatePackageInstalled'] ?? false;
    updatesStarted = map['updatesStarted'] ?? false;
    updateIterations = map['updateIterations'] ?? 0;
    updatesComplete = map['updatesComplete'] ?? false;

    uacEnabled = map['uacEnabled'] ?? false;

    cleanedUp = map['cleanedUp'] ?? false;
  }

  @override
  Map<String, dynamic> toMap() => {
        'chocoInstalled': chocoInstalled,
        'choco_firefox': choco_firefox,
        'choco_adobereader': choco_adobereader,
        'choco_vlc': choco_vlc,
        'choco_libreoffice': choco_libreoffice,
        //
        'updatePackageInstalled': updatePackageInstalled,
        'updatesStarted': updatesStarted,
        'updateIterations': updateIterations,
        'updatesComplete': updatesComplete,
        //
        'uacEnabled': uacEnabled,
        //
        'cleanedUp': cleanedUp,
      };
}
