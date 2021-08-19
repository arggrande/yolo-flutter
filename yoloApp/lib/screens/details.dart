import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoloapp/models/userStatsResponse.dart';
import 'package:yoloapp/util/trackerApiClient.dart';

class Details extends StatefulWidget {
  Details({Key? key, required DetailsArguments details})
      : _userId = details.userId,
        _platform = details.platform,
        super(key: key);

  final String _userId;
  final String _platform;
  static const String routeName = '/details';

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class DetailsArguments {
  final String userId;
  final String platform;

  DetailsArguments({required this.userId, required this.platform});
}

class _DetailState extends State<Details> {
  late Future<UserStatsResponse> _user;
  late final TrackerApiClient _client;
  final List<Item> _panelData = [
    Item(headerValue: 'Overview', expandedValue: '')
  ];

  @override
  void initState() {
    super.initState();

    _client = new TrackerApiClient();
    _user = getUserDetails();
  }

  Future<UserStatsResponse> getUserDetails() async {
    var user = await _client.getUser(widget._userId, widget._platform);

    return user;
  }

  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<UserStatsResponse>(
              future: _user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return renderDetailsDrawer(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              })
        ],
        crossAxisAlignment: CrossAxisAlignment.center);
  }

  Widget renderDetailsDrawer(UserStatsResponse user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Image.network(user.platform.avatarUrl),
        ),
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _panelData[index].isExpanded = !isExpanded;
            });
          },
          children: [_renderOverview(user)],
        )
      ],
    );
  }

  ExpansionPanel _renderOverview(UserStatsResponse user) {
    final overviewItem = _panelData[0];

    return ExpansionPanel(
        isExpanded: overviewItem.isExpanded,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(title: Text(overviewItem.headerValue));
        },
        body: Column(
          // Could also do a grid here maybe
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Handle: '),
                  Text(user.platform.platformUserHandle)
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('Steam Identifier: '),
                    Text(user.platform.platformUserIdentifier)
                  ],
                )),
          ],
        ));
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
