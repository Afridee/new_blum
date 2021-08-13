import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange);
  final bool enabled;
  final List<int> bandLevelRange;

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  double min, max;
  String _selectedValue;
  Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = Equalizer.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    int bandId = 0;

    return FutureBuilder<List<int>>(
      future: Equalizer.getCenterBandFreqs(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data
                        .map((freq) =>
                            Expanded(child: _buildSliderBand(freq, bandId++)))
                        .toList(),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildPresets(),
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250.0,
          child: FutureBuilder<int>(
            future: Equalizer.getBandLevel(bandId),
            builder: (context, snapshot) {
              return FlutterSlider(
                disabled: !widget.enabled,
                handlerAnimation: FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.bounceIn,
                    duration: Duration(milliseconds: 500),
                    scale: 1.5),
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                    border: Border.all(width: 3, color: Colors.blue),
                  ),
                  activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green.withOpacity(0.5)),
                ),
                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Material(
                    type: MaterialType.card,
                    color: Colors.transparent,
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.deepPurple,
                      ),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.chevron_up_circle,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                axis: Axis.vertical,
                decoration: BoxDecoration(
                  // color: Color(0xff1f2139),
                  border: Border.all(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                rtl: true,
                min: min,
                max: max,
                values: [snapshot.hasData ? snapshot.data.toDouble() : 0],
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  Equalizer.setBandLevel(bandId, lowerValue.toInt());
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text(
            '${freq ~/ 1000} Hz',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPresets() {
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets.isEmpty) return Text('No presets available!');
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 0.3,
                color: Colors.grey,
              ),
            ),
            child: DropdownButtonFormField(
              dropdownColor: Color(0xff1f2128).withOpacity(0.9),
              isExpanded: true,
              icon: Icon(
                CupertinoIcons.sort_down,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                labelText: 'Available Presets',
                labelStyle: TextStyle(color: Colors.white),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              value: _selectedValue,
              style: TextStyle(color: Colors.white),
              onChanged: widget.enabled
                  ? (String value) {
                      Equalizer.setPreset(value);
                      setState(() {
                        _selectedValue = value;
                      });
                    }
                  : null,
              items: presets.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          );
        } else if (snapshot.hasError)
          return Text(snapshot.error);
        else
          return CircularProgressIndicator();
      },
    );
  }
}
