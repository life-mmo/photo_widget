import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../photo_provider.dart';
import 'asset_path_widget.dart';
import 'asset_widget.dart';
import 'pick_app_bar.dart';

typedef PreferredSizeWidget PickAppBarBuilder(BuildContext context);

class PhotoPickHomePage extends StatefulWidget {
  final PickAppBarBuilder appBarBuilder;

  final PickerDataProvider provider;

  const PhotoPickHomePage({
    Key key,
    @required this.provider,
    this.appBarBuilder,
  }) : super(key: key);

  @override
  _PhotoPickHomePageState createState() => _PhotoPickHomePageState();
}

class _PhotoPickHomePageState extends State<PhotoPickHomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.provider.pathList.isEmpty) {
      PhotoManager.getAssetPathList().then((value) {
        widget.provider.resetPathList(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appbar;
    if (widget.appBarBuilder != null) {
      final size = widget.appBarBuilder(context).preferredSize;
      appbar = PreferredSize(
        preferredSize: size,
        child: Builder(
          builder: (BuildContext context) {
            return widget.appBarBuilder(context);
          },
        ),
      );
    } else {
      appbar = PickAppBar(
        onTapClick: () {
          Navigator.pop(context, null);
        },
        provider: widget.provider,
      );
    }
    return Scaffold(
      appBar: appbar,
      body: AnimatedBuilder(
        animation: widget.provider.currentPathNotifier,
        builder: (BuildContext context, Widget child) => AssetPathWidget(
          path: widget.provider.currentPath,
          buildItem: (ctx, asset, thumbSize) {
            return PickAssetWidget(
              asset: asset,
              provider: widget.provider,
              thumbSize: thumbSize,
            );
          },
          onAssetItemClick: (ctx, asset) {
            print(asset);
          },
        ),
      ),
    );
  }
}
