import 'package:Kide/pages/AboutUsPage.dart/AboutUs.dart';
import 'package:Kide/pages/Auth/Login.dart';
import 'package:Kide/pages/Profile/EditProfile.dart';
import 'package:Kide/pages/Profile/profile.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String name = '';
  String email = '';
  int ct = 0;
  bool isDarkModeEnabled = false;

  @override
  void initState() {
    fetchName();
    super.initState();
  }
  void fetchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('Name');
      email = prefs.getString('Email');
    });
  }

  _changeBrightness(context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    if (ct == 0) {
      isDarkModeEnabled =
          Theme.of(context).brightness == Brightness.dark ? true : false;
      ct++;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: DynamicTheme.of(context).data.cardColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 22, fontFamily: "Quicksand"),
        ),
        backgroundColor: DynamicTheme.of(context).data.backgroundColor,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 12, right: 12, top: 15),
          children: <Widget>[
            Text(
              "General",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    leading: Icon(Icons.person),
                    title: Text(
                      "Profile Settings",
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                    title: Text(
                      "Edit Profile  ",
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                    leading: Icon(Icons.camera),
                  ),
                  ListTile(
                    title: Text(
                      "Push Notifications ",
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: SwitchListTile(
                        activeColor: Colors.red,
                        value: true,
                        onChanged: (v) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Support",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Choose subject'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FlatButton.icon(
                                  onPressed: () {
                                    _createEmail(
                                        '[FEEDBACK]: $name : $email');
                                  },
                                  icon: Icon(Icons.feedback),
                                  label: Text("Feedback"),
                                ),
                                FlatButton.icon(
                                  onPressed: () {
                                    _createEmail('[HELP]: $name : $email');
                                  },
                                  icon: Icon(Icons.help),
                                  label: Text("Help"),
                                ),
                              ],
                            ),
                            actions: [
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.close),
                                label: Text("Cancel"),
                              ),
                            ],
                          ),
                        );
                      },

                    leading: Icon(Icons.help),
                    title: Text(
                      "Help & Feedback",
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUs(),
                        ),
                      );
                    },
                    title: Text(
                      "About Us",
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                    leading: Icon(Icons.info),
                  ),
                  ListTile(
                    onTap: () async {
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('loggedOut', true);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(fontFamily: "Quicksand", fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _createEmail(String subject) async {
  String emailaddress = 'mailto:kide.kiit@gmail.com?subject=$subject';

  if (await canLaunch(emailaddress)) {
    await launch(emailaddress);
  } else {
    throw 'Could not Email';
  }
}