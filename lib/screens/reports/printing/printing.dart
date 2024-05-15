import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smart_scarecrow/services/stream/motion.dart';
import 'package:smart_scarecrow/services/stream/soil_moisture.dart';
import 'package:smart_scarecrow/services/stream/sound.dart';
import 'package:smart_scarecrow/utils/palettes/colors.dart';

class Printing extends StatefulWidget {
  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                child: pw.Text("WEEKLY REPORT", style: pw.TextStyle(fontSize: 20)),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text('No. of Weeks', style: pw.TextStyle(fontSize: 18)),
                      )
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text('Soil', style: pw.TextStyle(fontSize: 18)),
                      )
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text('Motion', style: pw.TextStyle(fontSize: 18)),
                      )
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text('Sound', style: pw.TextStyle(fontSize: 18)),
                      )
                    ),
                  ]),

                  pw.TableRow(children: [
                    pw.Center(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('Week 1', style: pw.TextStyle(fontSize: 16)),
                        )
                    ),
                    pw.Center(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text(soilStreamServices.value! < 300 ? "Not healthy" : soilStreamServices.value! > 300 && soilStreamServices.value! < 650 ? "Moderate" : "Healthy", style: pw.TextStyle(fontSize: 16)),
                        )
                    ),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          for(int d = 0; d < motionStreamServices.valueTime!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toList().length; d++)...{
                            pw.Text(DateFormat('hh:mm:ss a').format(DateTime.parse(motionStreamServices.valueTime!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toList()[d].time.toString())), style: pw.TextStyle(fontSize: 16)),
                          }
                        ],
                      ),
                    ),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          for(int d = 0; d < soundStreamServices.valueTime!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toList().length; d++)...{
                            pw.Text(DateFormat('hh:mm:ss a').format(DateTime.parse(soundStreamServices.valueTime!.where((s) => DateFormat("dd MMM, yyyy").format(DateTime.parse(s.time)).toString() == DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toList()[d].time.toString())), style: pw.TextStyle(fontSize: 16)),
                          }
                        ],
                      ),
                    )
                  ])
                ],
              )
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print report",style: TextStyle(fontFamily: "bold",fontSize: 17),),
        centerTitle: true,
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        previewPageMargin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        build: (format) => _generatePdf(format, "Print this one"),
      ),
    );
  }
}
