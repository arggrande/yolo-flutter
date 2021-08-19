import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoloapp/components/fancyButton.dart';
import 'package:yoloapp/models/trackerApiResponse.dart';
import 'package:yoloapp/screens/searchResults.dart';
import 'package:yoloapp/util/trackerApiClient.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchForm(),
    );
  }
}

class SearchForm extends StatefulWidget {
  SearchForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  String query = '';
  final TrackerApiClient _client = new TrackerApiClient();

  late List<TrackerApiResponse>? _resultState = [];
  List<TrackerApiResponse>? get results => _resultState;
  set results(List<TrackerApiResponse>? value) {
    _resultState = value;
  }

  final _formKey = GlobalKey<FormState>();
  late final FancyController _buttonController;

  Future<void> getData() async {
    try {
      var apiResults = await _client.search(query);
      setState(() {
        results = apiResults;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void onCancel() {
    setState(() {
      _buttonController.status = Status.stopped;
    });
  }

  void onOpen() {
    Navigator.pushNamed(context, SearchResults.routeName, arguments: results);
  }

  @override
  void initState() {
    super.initState();

    _buttonController = new FancyController(
        onStart: getData, onCancel: onCancel, onOpenResult: onOpen);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Search for a Player!',
                        style: TextStyle(fontSize: 25),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      TextFormField(
                          autofocus: true,
                          onChanged: textChanged,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)),
                      Padding(padding: EdgeInsets.all(20)),
                      FancyButton(
                          text: 'Search',
                          progress: _buttonController.progress,
                          status: _buttonController.status,
                          onStart: _buttonController.onStart,
                          onCancel: _buttonController.onCancel,
                          onOpenResult: _buttonController.onOpenResult),
                      if (_resultState?.isNotEmpty ?? false)
                        Stack(
                          children: [
                            Padding(padding: EdgeInsets.all(20)),
                            Text(
                                'results found, first player is: ${results?.first.platformUserHandle}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 15))
                          ],
                        ),
                    ],
                  )),
                )
              ]))
    ]);
  }

  void textChanged(String value) {
    // We could probably also use TextControllers here instead of manually wiring up to the onChanged event of our TextFormField
    setState(() {
      query = value;
    });
  }
}
