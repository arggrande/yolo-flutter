import 'package:flutter/material.dart';
import 'package:yoloapp/components/fancyButton.dart';
import 'package:yoloapp/models/trackerApiResponse.dart';

import 'details.dart';

class SearchResults extends StatelessWidget {
  SearchResults({Key? key, required this.results});
  final List<TrackerApiResponse> results;

  static const String routeName = '/results';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('People')),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.separated(
        itemBuilder: _buildListItem,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: results.length);
  }

  Widget _buildListItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final controller = FancyController(
        status: Status.finished,
        onOpenResult: () {
          onOpenResult(context, index);
        },
        onStart: onStart,
        onCancel: onCancel);
    final item = results[index];

    return ListTile(
      leading: Avatar(avatarUrl: item.avatarUrl),
      title: Text(
        item.platformUserHandle,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.headline6,
      ),
      subtitle: (Text(item.platformSlug,
          overflow: TextOverflow.ellipsis, style: theme.textTheme.caption)),
      trailing: SizedBox(
        width: 96.0,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return FancyButton(
                status: controller.status,
                progress: controller.progress,
                onStart: controller.onStart,
                onCancel: controller.onCancel,
                onOpenResult: controller.onOpenResult,
                text: 'Open');
          },
        ),
      ),
    );
  }

  void onOpenResult(BuildContext context, int index) {
    final user = results[index];
    Navigator.pushNamed(context, Details.routeName,
        arguments: DetailsArguments(
            userId: user.platformUserId, platform: user.platformSlug));
  }

  Future<void> onStart() async {}

  void onCancel() {}
}

@immutable
class Avatar extends StatelessWidget {
  const Avatar({Key? key, required String avatarUrl})
      : _avatarUrl = avatarUrl,
        super(key: key);

  final String _avatarUrl;

  @override
  Widget build(BuildContext context) {
    var img = Image.network(_avatarUrl);
    return AspectRatio(
        aspectRatio: 1.0,
        child: FittedBox(
            child: SizedBox(
                width: 80.0,
                height: 80.0,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.purple, Colors.black]),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Center(child: img)))));
  }
}
