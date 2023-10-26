import 'package:flutter/material.dart';
import 'package:flutter_institutions_testcase/model/institution.dart';
import 'package:flutter_svg/svg.dart';
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
      appBar: appBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/tbmm.jpg',
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  (institution.title),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.mail,
                      size: 35,
                    ),
                    title: const Text('Email'),
                    subtitle: Text(institution.email),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.link,
                      size: 35,
                    ),
                    title: const Text('Web Page'),
                    subtitle: Text(institution.link),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.map,
                      size: 35,
                    ),
                    title: const Text('Phone'),
                    subtitle: Text(institution.tel),
                    trailing: ElevatedButton(
                        onPressed: () {
                          _makePhoneCall(institution.tel);
                        },
                        child: const Text("Call")),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey.shade200,
                        spreadRadius: 2,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.map,
                      size: 35,
                    ),
                    title: const Text('Adress'),
                    subtitle: Text(institution.adres),
                    trailing: ElevatedButton(
                        onPressed: () {
                          gotoMap();
                        },
                        child: const Text("Go Map")),
                  ),
                ),
              ],
            ),
          )

          // Container(
          //   padding: const EdgeInsets.all(2),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(5),
          //     color: Colors.grey.shade200,
          //   ),
          //   child: Card(
          //     elevation: 2,
          //     child: Text(institution.title.toString()),
          //   ),
          // ),
          // Text('Email: ${institution.email}'),
          // Text('Code: ${institution.code}'),
          // ElevatedButton.icon(
          //     onPressed: () {
          //       _makePhoneCall(institution.tel);
          //     },
          //     icon: const Icon(Icons.call),
          //     label: const Text("Call")),
          // ElevatedButton.icon(
          //     onPressed: () {
          //       gotoMap();
          //     },
          //     icon: const Icon(Icons.map),
          //     label: const Text("Call")),
          // Text(infoText),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Institution App',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
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
