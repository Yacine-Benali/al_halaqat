import 'package:alhalaqat/app/home/approved/globalAdmin/ga_config/ga_config_provider.dart';
import 'package:alhalaqat/app/models/ga_config.dart';
import 'package:flutter/material.dart';

class GaConfigBloc {
  GaConfigBloc({@required this.provider});

  final GaConfigProvider provider;

  Future<void> updategaConfig(GaConfig gaConfig) async =>
      await provider.updateGaConfig(gaConfig);

  Future<GaConfig> readgaConfig() async => await provider.readGaConfig();
}
