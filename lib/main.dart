import 'package:flutter/material.dart';
import 'package:flutter_application_danabot/bloc/data_bloc.dart';
import 'package:flutter_application_danabot/bloc/data_event.dart';
import 'package:flutter_application_danabot/bloc/data_state.dart';
import 'package:flutter_application_danabot/comp.dart';
import 'package:flutter_application_danabot/retdio/retdio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      LottiePage(),
      BlocProvider(
        create: (context) => DataBloc(Controlapi(dio)),
        child: DataPage(),
      ),
      LottiePage2(),
      Qrcode()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Navigation App')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Дом'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Работа'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Аккаунт'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2_outlined), label: 'QR'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class LottiePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/Anim.json'),
    );
  }
}

class DataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.add(FetchCommentsEvent());

    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          return ListView.builder(
            itemCount: state.comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.comments[index].name),
                subtitle: Text(
                    'Email: ${state.comments[index].email}\nBody: ${state.comments[index].body}'),
              );
            },
          );
        } else if (state is DataError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class LottiePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/Animation.json'),
    );
  }
}

class Qrcode extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<Qrcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (qrText != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Содержимое QR-кода: $qrText'),
            ),
          ElevatedButton(
            onPressed: () {
              controller?.dispose();
              Navigator.pop(context);
            },
            child: Text('Стоп и вернуться'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
      print('Scanned QR: $qrText');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
