export 'paginated_list.dart';
export 'content/content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider networkImage(String url, {double scale = 1.0}) {
  return CachedNetworkImageProvider(
    url,
    scale: scale,
  );
}
