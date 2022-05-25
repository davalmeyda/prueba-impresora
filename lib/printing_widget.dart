import 'dart:io';

import 'package:proyecto_impresora/blue_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:image/image.dart' as img;

FlutterBlue flutterBlue = FlutterBlue.instance;

class PrintingWidget extends StatefulWidget {
  const PrintingWidget({Key? key}) : super(key: key);

  @override
  _PrintingWidgetState createState() => _PrintingWidgetState();
}

class _PrintingWidgetState extends State<PrintingWidget> {
  List<ScanResult>? scanResult;

  @override
  void initState() {
    super.initState();
    findDevices();
  }

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResult = results;
      });
    });
    flutterBlue.stopScan();
  }

  void printWithDevice(BluetoothDevice device) async {
    await device.connect();
    final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
    final printer = BluePrint();
    // printer.add(gen.qrcode('20607455628|03|B001|00000041|0.00|150|2022-05-24|1|47813783|SZDI1gfdV+srVudW6w6dr36Ltf8='));
    // printer.add(gen.text('Hello'));
    // printer.add(gen.text('World', styles: const PosStyles(bold: true)));
    // printer.add(gen.feed(1));
    img.Image? image =
        img.decodeJpg(File('assets/boleta-prueba.png').readAsBytesSync());
    printer.add(gen.image(image!));
    await printer.printData(device);
    device.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth devices')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scanResult![index].device.name),
            subtitle: Text(scanResult![index].device.id.id),
            onTap: () => printWithDevice(scanResult![index].device),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: scanResult?.length ?? 0,
      ),
    );
  }
}
