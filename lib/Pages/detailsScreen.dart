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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/tbmm.jpg',
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildDetails(),
          )
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
            color: Colors.deepOrange,
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
      throw 'The phone call couldn\'t be initiated: $telScheme';
    }
  }

  gotoMap() {
    try {
      var address = institution.adres;
      final Uri url =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
      launchUrl(url);
    } catch (e) {
      debugPrintStack();
    }
  }

  Widget _buildDetails() {
    return Column(
      children: [
        Text(
          (institution.title),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        _buildCustomListTile(
          Icons.mail,
          'Email',
          institution.email,
        ),
        const SizedBox(height: 20),
        _buildCustomListTile(
          Icons.link,
          'Web Page',
          institution.link,
        ),
        const SizedBox(height: 20),
        _buildCustomListTile(
          Icons.phone,
          'Phone',
          institution.tel,
          onPressed: () {
            _makePhoneCall(institution.tel);
          },
          buttonText: 'Call',
        ),
        const SizedBox(height: 20),
        _buildCustomListTile(
          Icons.map,
          'Address',
          institution.adres,
          onPressed: () {
            gotoMap();
          },
          buttonText: 'Go Map',
        ),
      ],
    );
  }

  Widget _buildCustomListTile(
    IconData leadingIcon,
    String title,
    String subtitle, {
    VoidCallback? onPressed,
    String? buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.grey.shade200,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          leadingIcon,
          size: 35,
          color: Colors.deepOrange,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: buttonText != null
            ? ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
