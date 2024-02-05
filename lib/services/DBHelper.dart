import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'package:fyp/dbModels.dart';

class DBHelper {
  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'fyp.db'),
      onCreate: (database, version) {
        database.execute(
          '''
          CREATE TABLE Worker(
            worker_id INTEGER PRIMARY KEY NOT NULL,
            worker_fname TEXT NOT NULL,
            worker_sname TEXT NOT NULL,
            worker_bday TEXT NOT NULL,
            worker_email TEXT NOT NULL,
            worker_location TEXT NOT NULL
          )
          '''
        );
        database.execute(
          '''
          CREATE TABLE Availability(
            available_id INTEGER PRIMARY KEY NOT NULL,
            worker_id INTEGER NOT NULL,
            week_day TEXT NOT NULL,
            day_start_time TEXT NOT NULL,
            day_end_time TEXT NOT NULL,
            miles INTEGER NOT NULL,
            FOREIGN KEY (worker_id) REFERENCES Worker(worker_id)
          )
          '''
        );
        database.execute(
          '''
          CREATE TABLE Company(
            company_id INTEGER PRIMARY KEY NOT NULL,
            company_name TEXT NOT NULL,
            company_email TEXT NOT NULL,
            company_location TEXT NOT NULL
          )
          '''
        );
        database.execute(
          '''
          CREATE TABLE Job(
            job_id INTEGER PRIMARY KEY NOT NULL,
            company_id INTEGER NOT NULL,
            job_status TEXT NOT NULL,
            job_day TEXT NOT NULL,
            job_start_time TEXT NOT NULL,
            job_end_time TEXT NOT NULL,
            job_location TEXT NOT NULL,
            FOREIGN KEY (company_id) REFERENCES Company(company_id)
          )
          '''
        );
        database.execute(
          '''
          CREATE TABLE AssignedJobs(
            assign_id INTEGER PRIMARY KEY NOT NULL,
            job_id INTEGER NOT NULL,
            company_id INTEGER NOT NULL,
            worker_id INTEGER NOT NULL,
            worker_complete INTEGER NOT NULL,
            company_complete INTEGER NOT NULL,
            FOREIGN KEY (job_id) REFERENCES Jobs(job_id),
            FOREIGN KEY (company_id) REFERENCES Company(company_id),
            FOREIGN KEY (worker_id) REFERENCES Worker(worker_id)
          )
          '''
        );
      },
      version: 1,
    );
  }

  Future<void> insertWorker(List<Worker> workers) async {
    final Database db = await initializeDB();
    for (var worker in workers) {
      await db.insert('Worker', worker.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertAvailable(List<Availability> availabilities) async {
    final Database db = await initializeDB();
    for (var worker in availabilities) {
      await db.insert('Availability', worker.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertCompany(List<Company> companies) async {
    final Database db = await initializeDB();
    for (var company in companies) {
      await db.insert('Company', company.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertJob(List<Job> jobs) async {
    final Database db = await initializeDB();
    for (var job in jobs) {
      await db.insert('Job', job.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertAssignJob(List<AssignedJobs> jobs) async {
    final Database db = await initializeDB();
    for (var job in jobs) {
      await db.insert('AssignedJobs', job.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

}
