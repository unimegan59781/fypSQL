import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/dbModels.dart';
import 'package:fyp/services/DBHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DBHelper dbHelper;

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  Future<void> addDB() async {
    final workerCSV = await rootBundle.loadString("assets/workers_datafile.csv");
    List<List<dynamic>> workerList = const CsvToListConverter().convert(workerCSV);
    List<Worker> workers = [];
    for (var line in workerList) {
      Worker newWorker = Worker(
        worker_id: line[0],
        worker_fname: line[1],
        worker_sname: line[3],
        worker_bday: DateTime(line[4]),
        worker_email: line[5],
        worker_location: line[6],
      );
      workers.add(newWorker);
    }
    final availCSV = await rootBundle.loadString("assets/avail_datafile.csv");
    List<List<dynamic>> availList = const CsvToListConverter().convert(availCSV);
    List<Availability> avail = [];
    for (var line in availList) {
      Availability newAvail = Availability(
        available_id: line[0],
        worker_id: line[1],
        week_day: line[2],
        day_start_time: line[3],
        day_end_time: line[4],
        miles: line[5],
      );
      avail.add(newAvail);
    }
    final companyCSV = await rootBundle.loadString("assets/company_datafile.csv");
    List<List<dynamic>> companyList = const CsvToListConverter().convert(companyCSV);
    List<Company> compaines = [];
    for (var line in companyList) {
      Company newCompany = Company(
        company_id: line[0],
        company_name: line[1],
        company_email: line[2],
        company_location: line[3],
      );
      compaines.add(newCompany);
    }
    final jobCSV = await rootBundle.loadString("assets/job_datafile.csv");
    List<List<dynamic>> jobList = const CsvToListConverter().convert(jobCSV);
    List<Job> jobs = [];
    for (var line in jobList) {
      Job newJob = Job(
        job_id: line[0],
        company_id: line[1],
        job_status: line[2],
        job_date: line[3],
        job_start_time: line[4],
        job_end_time: line[5],
        job_location: line[6],
      );
      jobs.add(newJob);
    }
    await dbHelper.insertWorker(workers);
    await dbHelper.insertAvailable(avail);
    await dbHelper.insertCompany(compaines);
    await dbHelper.insertJob(jobs);
    
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
