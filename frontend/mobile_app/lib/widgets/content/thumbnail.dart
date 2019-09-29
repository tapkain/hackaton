import 'package:flutter/material.dart';
import 'package:newlife_ai_mobile/shared/widgets/widgets.dart';
import 'package:newlife_ai_mobile/shared/repository/repository.dart';
import 'package:newlife_ai_mobile/shared/util/util.dart';
import 'package:newlife_ai_mobile/shared/strings.dart';

class ThumbnailWidget extends StatelessWidget {
  final PostModel post;
  final Function onTap;
  final iconSize = WidgetConstants.smallIconSize / 1.3;
  Function dismissPostPreview;

  ThumbnailWidget({this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = Endpoint.thumbnailUrl(post.thumbnailHash);
    if (imageUrl == null || imageUrl == 'null_thumbnail') {
      return Container();
    }

    return GestureDetector(
        onTap: _onTap,
        onLongPressStart: (_) async {
          dismissPostPreview = await GodDialog.showPostPreview(post);
        },
        onLongPressEnd: (_) {
          dismissPostPreview();
        },
        child: _card(context, imageUrl));
  }

  _onTap() {
    if (post.isProcessing) {
      GodDialog.showToast(Strings.processingExplainer);
      return;
    }
    onTap();
  }

  Widget _card(BuildContext context, String imageUrl) {
    if (post.isUploading) {
      return GodShimmerLoading(
        caption: Strings.nodeIsUploading,
        captionSpacing: 100,
      );
    }

    if (post.isProcessing) {
      return GodShimmerLoading(
        caption: Strings.processing,
        captionSpacing: 100,
      );
    }

    return Card(
      color: Theme.of(context).accentColor,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: <Widget>[
          FadeInImage(
            placeholder: AssetImage(Assets.placeholder),
            image: networkImage(imageUrl),
            width: post.thumbnailSize.item1,
            height: post.thumbnailSize.item2,
            fit: BoxFit.cover,
          ),
          _buildPositionedContentIcon(),
          _buildRepostIcon(),
        ],
      ),
    );
  }

  Widget _buildContentIcon() {
    if (post.videos.length > 0) {
      return Image.asset(
        Assets.video,
        width: iconSize,
        height: iconSize,
      );
    }

    if (post.sounds.length > 0) {
      return Image.asset(
        Assets.sound,
        width: iconSize,
        height: iconSize,
      );
    }

    return Container();
  }

  Widget _buildPositionedContentIcon() {
    return Positioned(
      right: 5,
      top: 5,
      child: _buildContentIcon(),
    );
  }

  Widget _buildRepostIcon() {
    if (post.parentPostId == null) {
      return Container();
    }

    return Positioned(
      left: 5,
      top: 5,
      child: Image.asset(
        Assets.repost,
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}
