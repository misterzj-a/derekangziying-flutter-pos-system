import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:packages/bluetooth.dart' as bt;
import 'package:possystem/components/imageable_container.dart';
import 'package:possystem/services/bluetooth.dart';
import 'package:packages/fbp.dart'; // 修复 FBP not found
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // 修复蓝牙类型不匹配
//import 'mock_bluetooth.mocks.dart';

final blue = MockBluetooth();

@GenerateMocks([
  bt.Bluetooth,
  bt.Printer,
  bt.BluetoothDevice,
  bt.PrinterManufactory,
  ImageableManger,
  ImageableController,
  FBP, // 👈 必须加上！修复 FBP 找不到
  BluetoothCharacteristic, // 👈 必须加上！修复类型不匹配
])
void initializeBlue() {
  Bluetooth.instance = Bluetooth(blue: blue);
}

MockImageableController prepareImageable([Future<List<ConvertibleImage>?>? result]) {
  final manger = ImageableManger.instance = MockImageableManger();
  final controller = MockImageableController();
  when(manger.create()).thenReturn(controller);
  when(controller.key).thenReturn(GlobalKey());
  when(controller.toImage(widths: anyNamed('widths')))
      .thenAnswer((_) => result ?? Future.value([ConvertibleImage(Uint8List(4), width: 1)]));

  return controller;
}

void resetImageable() {
  ImageableManger.instance = ImageableManger();
}
