// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:developer';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'a11y/a11y_gallery.dart' as a11y show buildGallery;
import 'app_config.dart';
import 'axes/axes_gallery.dart' as axes show buildGallery;
import 'bar_chart/bar_gallery.dart' as bar show buildGallery;
import 'behaviors/behaviors_gallery.dart' as behaviors show buildGallery;
import 'combo_chart/combo_gallery.dart' as combo show buildGallery;
import 'drawer.dart';
import 'gallery_scaffold.dart';
import 'i18n/i18n_gallery.dart' as i18n show buildGallery;
import 'legends/legends_gallery.dart' as legends show buildGallery;
import 'line_chart/line_gallery.dart' as line show buildGallery;
import 'pie_chart/pie_gallery.dart' as pie show buildGallery;
import 'scatter_plot_chart/scatter_plot_gallery.dart' as scatter_plot show buildGallery;
import 'time_series_chart/time_series_gallery.dart' as time_series show buildGallery;

/// Main entry point of the gallery app.
///
/// This renders a list of all available demos.
class Home extends StatefulWidget {
  final bool showPerformanceOverlay;
  final ValueChanged<bool> onShowPerformanceOverlayChanged;

  Home({Key key, this.showPerformanceOverlay, this.onShowPerformanceOverlayChanged}) : super(key: key) {
    assert(onShowPerformanceOverlayChanged != null);
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final a11yGalleries = a11y.buildGallery();
  final barGalleries = bar.buildGallery();
  final timeSeriesGalleries = time_series.buildGallery();
  final lineGalleries = line.buildGallery();
  final scatterPlotGalleries = scatter_plot.buildGallery();
  final comboGalleries = combo.buildGallery();
  final pieGalleries = pie.buildGallery();
  final axesGalleries = axes.buildGallery();
  final behaviorsGalleries = behaviors.buildGallery();
  final i18nGalleries = i18n.buildGallery();
  final legendsGalleries = legends.buildGallery();

  List<Widget> catalogGalleries;
  List<Widget> galleries;

  @override
  void initState() {
    super.initState();
    galleries = catalogGalleries = [
      ['a11y', '', Icons.accessibility, a11yGalleries],
      ['bar', 'bar charts', Icons.insert_chart, barGalleries],
      ['timeSeries', 'time series charts', Icons.access_time, timeSeriesGalleries],
      ['line', 'line charts', Icons.show_chart, lineGalleries],
      ['scatterPlot', 'scatter plot charts', Icons.scatter_plot, scatterPlotGalleries],
      ['combo', 'pie charts', Icons.multiline_chart, comboGalleries],
      ['pie', 'pie charts', Icons.pie_chart, pieGalleries],
      ['axis', 'custom axis', Icons.insert_chart, axesGalleries],
      ['behaviors', '', Icons.touch_app, behaviorsGalleries],
      ['i18n', '', Icons.language, i18nGalleries],
      ['legends', '', Icons.legend_toggle, legendsGalleries],
    ]
        .map((e) => ListTile(
              onTap: () {
                setState(() {
                  galleries = (e[3] as List<GalleryScaffold>).map((e) => e.buildGalleryListTile(context)).toList();
                });
              },
              title: Text(e[0]),
              subtitle: Text(e[1]),
              leading: Icon(e[2]),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: _build(context),
        onWillPop: () async {
          if (galleries != catalogGalleries) {
            setState(() {
              galleries = catalogGalleries;
            });
            return false;
          }
          return true;
        },
      );

  Widget _build(BuildContext context) {
    _setupPerformance();

    return new Scaffold(
      drawer: new GalleryDrawer(
        showPerformanceOverlay: widget.showPerformanceOverlay,
        onShowPerformanceOverlayChanged: widget.onShowPerformanceOverlayChanged,
      ),
      appBar: new AppBar(title: new Text(defaultConfig.appName)),
      body: new ListView(
        key: galleries == catalogGalleries ? PageStorageKey('catalog') : null,
        padding: kMaterialListPadding,
        children: galleries,
      ),
    );
  }

  void _setupPerformance() {
    // Change [printPerformance] to true and set the app to release mode to
    // print performance numbers to console. By default, Flutter builds in debug
    // mode and this mode is slow. To build in release mode, specify the flag
    // blaze-run flag "--define flutter_build_mode=release".
    // The build target must also be an actual device and not the emulator.
    charts.Performance.time = (String tag) => Timeline.startSync(tag);
    charts.Performance.timeEnd = (_) => Timeline.finishSync();
  }
}
