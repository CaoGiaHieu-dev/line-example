import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'main.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key, required this.result}) : super(key: key);
  final LoginResult result;

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late UserProfile? _profile;
  late AccessToken? _token;
  num _expires = 0;
  List<Widget>? _userInfo() {
    return _profile?.data.entries
        .map((e) => GroupInfo(
              title: e.key.toString(),
              content: e.value.toString(),
            ))
        .toList();
  }

  List<Widget>? _tokenInfo() {
    return _token?.data.entries.map((e) {
      if (e.key == 'expires_in') {
        _expires == 0 ? _expires = e.value : _expires = _expires;
        return GroupInfo(
          title: e.key,
          content: _expires.toString(),
        );
      } else {
        return GroupInfo(
          title: e.key.toString(),
          content: e.value.toString(),
        );
      }
    }).toList();
  }

  @override
  void initState() {
    _profile = widget.result.userProfile;
    _token = widget.result.accessToken;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Theme.of(context).backgroundColor,
                      onPressed: () {
                        try {
                          LineSDK.instance.getProfile().then((value) {
                            setState(() {
                              _profile = value;
                            });
                          }, onError: (e) {
                            log(e.toString());
                          });
                        } on PlatformException catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text('Get Info'),
                    ),
                    MaterialButton(
                      color: Theme.of(context).backgroundColor,
                      onPressed: () {
                        try {
                          LineSDK.instance.refreshToken().then((value) {
                            setState(() {
                              _token = value;
                            });
                          }, onError: (e) {
                            log(e.toString());
                          });
                        } on PlatformException catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text('Refesh token'),
                    ),
                    MaterialButton(
                      color: Theme.of(context).backgroundColor,
                      onPressed: () {
                        try {
                          LineSDK.instance.verifyAccessToken().then((value) {
                            setState(() {
                              _expires = value.expiresIn;
                            });
                          }, onError: (e) {
                            log(e.toString());
                          });
                        } on PlatformException catch (e) {
                          log(e.toString());
                        }
                      },
                      child: const Text('verify token'),
                    ),
                  ],
                ),
                const Text('User Info'),
                ..._userInfo() ?? [],
                const Text('Token'),
                ..._tokenInfo() ?? [],
                MaterialButton(
                  color: Theme.of(context).backgroundColor,
                  onPressed: () {
                    try {
                      LineSDK.instance.logout().whenComplete(() =>
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const MyHomePage();
                          }), (route) => false));
                    } on PlatformException catch (e) {
                      log(e.toString());
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupInfo extends StatelessWidget {
  const GroupInfo({Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Text(title)),
          Expanded(
            flex: 3,
            child: Text(content),
          ),
        ],
      ),
    );
  }
}
