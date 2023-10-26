import 'package:flutter/material.dart';
import 'package:flutter_institutions_testcase/model/institution.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class detailsScreen extends StatefulWidget {
  final Institution institution;

  detailsScreen(this.institution);

  @override
  State<detailsScreen> createState() => _detailsScreenState(institution);
}

class _detailsScreenState extends State<detailsScreen> {
  final Institution institution;
  String infoText = "";
  _detailsScreenState(this.institution);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(institution.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Title: ${institution.title}'),
            Text('Email: ${institution.email}'),
            Text('Code: ${institution.code}'),
            ElevatedButton.icon(
                onPressed: () {
                  _makePhoneCall(institution.tel);
                },
                icon: const Icon(Icons.call),
                label: const Text("Call")),
            ElevatedButton.icon(
                onPressed: () {
                  gotoMap();
                },
                icon: const Icon(Icons.map),
                label: const Text("Call")),
            Text(infoText),
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';

    if (await canLaunchUrlString(telScheme)) {
      await launchUrlString(telScheme);
    } else {
      throw 'Telefon görüşmesi başlatilamadi: $telScheme';
    }
  }

  gotoMap() {
    try {
      var address = institution.adres;
      final Uri _url =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
      launchUrl(_url);
    } catch (e) {
      debugPrintStack();
    }
  }
}
