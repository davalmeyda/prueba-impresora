import 'dart:io';

import 'package:flutter/services.dart';
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
    // printer.add(gen.text('Beyzon Corp. S.A.C.',
    //     styles: PosStyles(align: PosAlign.center, bold: true)));
    // printer.add(gen.text('RUC 20607455628',
    //     styles: PosStyles(align: PosAlign.center, bold: true)));
    // printer.add(gen.text(
    //     'CALLE LOS GUAYABOS NRO. 489 COO. VILLA DEL MAR, EL AGUSTINO - LIMA - LIMA',
    //     styles: PosStyles(align: PosAlign.center)));
    // printer.add(gen.text('--------------------------------',
    //     styles: PosStyles(align: PosAlign.center)));
    printer.add(gen.text('BOLETA DE VENTA ELECTRONICA',
        styles: PosStyles(bold: true, align: PosAlign.center)));
    printer.add(gen.text('B001-00000036',
        styles: PosStyles(bold: true, align: PosAlign.center)));
    printer.add(gen.emptyLines(1));
    printer.add(gen.row([
      PosColumn(
        text: 'NOMBRE:',
        width: 5,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: 'DAVID MARTIN ALMEYDA SUCSO',
        width: 7,
        styles: PosStyles(bold: false),
      )
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'DNI:',
        width: 5,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: '47813783',
        width: 7,
        styles: PosStyles(bold: false),
      )
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'EMISION:',
        width: 5,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: '2022-05-24',
        width: 7,
        styles: PosStyles(bold: false),
      )
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'MONEDA:',
        width: 5,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: 'SOL (PEN)',
        width: 7,
        styles: PosStyles(bold: false),
      )
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'OPERACION:',
        width: 5,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: 'VENTAS NO DOMICILIADOS QUE NO CALIFICAN COMO EXPORTACION',
        width: 7,
        styles: PosStyles(bold: false),
      )
    ]));
    printer.add(gen.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    printer.add(gen.text('DESCRIPCION'));
    printer.add(gen.row([
      PosColumn(
        text: 'CANT',
        width: 4,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: 'P.UNIT',
        width: 4,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: 'P.TOTAL',
        width: 4,
        styles: PosStyles(bold: true),
      ),
    ]));
    printer.add(gen.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    printer.add(gen.text('VENTA DE 0.8 USD'));
    printer.add(gen.row([
      PosColumn(
        text: '1 UNIDAD',
        width: 4,
        styles: PosStyles(bold: false),
      ),
      PosColumn(
        text: '3.000',
        width: 4,
        styles: PosStyles(bold: false),
      ),
      PosColumn(
        text: '3.00',
        width: 4,
        styles: PosStyles(bold: false),
      ),
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'OP. INAFECTA',
        width: 8,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: '3.000',
        width: 4,
        styles: PosStyles(bold: false),
      ),
    ]));
    printer.add(gen.row([
      PosColumn(
        text: 'IGV',
        width: 8,
        styles: PosStyles(bold: true),
      ),
      PosColumn(
        text: '-',
        width: 4,
        styles: PosStyles(bold: false),
      ),
    ]));
    printer.add(gen.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center)));
    printer.add(gen.text('IMPORTE TOTAL S/. 3.00',
        styles: PosStyles(align: PosAlign.right, bold: true)));
    printer.add(gen.text('--------------------------------',
        styles: PosStyles(align: PosAlign.center)));

    printer.add(gen.text(
        'Representacion Impresa de la BOLETA DE VENTA ELECTRONICA',
        styles: PosStyles(align: PosAlign.center)));
    // printer.add(gen.emptyLines(2));
    // printer.add(gen.drawer());
    // printer.add(gen.text('RUC 20607455628',
    //     styles: PosStyles(align: PosAlign.center, bold: true)));
    printer.add(gen.qrcode(
      '20607455628|03|B001|00000041|0.00|150|2022-05-24|1|47813783|SZDI1gfdV+srVudW6w6dr36Ltf8=',
      size: QRSize.Size5,
      align: PosAlign.center,
    ));
    // printer.add(gen.text('Hello'));
    // printer.add(gen.text('World', styles: const PosStyles(bold: true)));
    // printer.add(gen.feed(1));
    final aaa = await rootBundle.load('assets/boleta-prueba.png');
    img.Image? image = img.PngDecoder().decodeImage(aaa.buffer.asUint8List());
    // printer.add(gen.image(image!));
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
