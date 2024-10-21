import 'package:flutter/material.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:my_vaccine_app/screens/measurment/measurementView.dart';
import 'package:my_vaccine_app/screens/measurment/weightofBoys.dart';
import 'package:my_vaccine_app/screens/measurment/weighttogirls.dart';

class MeasurementHome extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  const MeasurementHome({Key? key, this.navigatorKey}) : super(key: key);

  @override
  _MeasurementHomeState createState() => _MeasurementHomeState();
}

class _MeasurementHomeState extends State<MeasurementHome> {
  String _headline = '';
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void navigateToMeasurementWeight(BuildContext context) {
    widget.navigatorKey?.currentState?.push(
      MaterialPageRoute(builder: (context) => MeasurementWeight()),
    );
  }

  void navigateToMeasurementWeightGirls(BuildContext context) {
    widget.navigatorKey?.currentState?.push(
      MaterialPageRoute(builder: (context) => MeasurementWeightGirls()),
    );
  }

  List<CollapsibleItem> get _items {
    return [
      CollapsibleItem(
        text: 'Boys',
        icon: Icons.ac_unit,
        onPressed: () => setState(() => _headline = 'Boys'),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Boys")),
        ),
      ),
      CollapsibleItem(
        text: 'Length/height-for-age Boys\n Birth to 5 years(z-scores)',
        badgeCount: 7,
        icon: Icons.assessment,
        onPressed: () {
          print('hello');
          try {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MeasurementWeight()),
            );
          } catch (e) {
            print('Navigation Error: $e');
          }
        },
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Length/height-for-age Boys")),
        ),
      ),

      // Girls Section
      CollapsibleItem(
        text: 'Girls',
        icon: Icons.ac_unit,
        onPressed: () => setState(() => _headline = 'Girls'),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Girls")),
        ),
      ),
      CollapsibleItem(
        text: 'Length/height-for-age Girls\n Birth to 5 years (z-scores)',
        badgeCount: 7,
        icon: Icons.assessment,
        onPressed: () {
          try {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MeasurementWeightGirls()),
            );
          } catch (e) {
            print('Navigation Error: $e');
          }
        },
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Length/height-for-age Girls")),
        ),
      ),
      // Measurement Table Section
      CollapsibleItem(
        
        text: 'MeasurementTable',
        icon: Icons.ac_unit,
        onPressed: () => setState(() => _headline = 'Measurement'),
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("MeasurementTable")),
        ),
      ),
      CollapsibleItem(
        text: 'Measurement Table View',
        badgeCount: 7,
        icon: Icons.assessment,
        onPressed: () {
          try {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MeasurementTable()),
            );
          } catch (e) {
            print('Navigation Error: $e');
          }
        },
        onHold: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Measurement Table Views")),
        ),
      ),
    ];
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          title: Text(item.text),
          onTap: () {
            item.onPressed?.call();
            Navigator.of(context).pop();
          },
          onLongPress: () => item.onHold?.call(),
          selected: item.isSelected ?? false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('قياسات الطفل'),
            ],
          ),
        ),
        drawer: Drawer(
          child: _buildBody(),
        ),
        body: Container(
          child: Center(
            child: Text(_headline),
          ),
        ),
      ),
    );
  }
}
