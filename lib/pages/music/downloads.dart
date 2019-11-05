import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'dart:io';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DownloadedMusic extends StatefulWidget {
  @override
  _DownloadedMusicState createState() => _DownloadedMusicState();
}

class _DownloadedMusicState extends State<DownloadedMusic> {
  final _locator = locator<MusicService>();
  Future<List<Track>> getDownloadData() async {
    Database db;
    var downloadpath = await getDatabasesPath();
    String path = join(downloadpath, 'data.db');
    db = await openDatabase(path, version: 1);
    var fb = await db.rawQuery('select * from download');
    var a = fb.map<Track>((data) => Track.fromDownload(data));
    List<Track> favs = [];
    favs.addAll(a);
    return favs;
  }

  void deleteDown(int id) async {
    Database db;
    var downloadpath = await getDatabasesPath();
    String path = join(downloadpath, 'data.db');
    db = await openDatabase(path, version: 1);
    var d = await db.rawQuery('select url from download where id=$id');
    File file = File(d[0]['url']);
    file.delete();
    await db.rawDelete('delete from  download where id=$id');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _deleteMusic(int id) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              // height: 370.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100.0,
                          child: Image.asset(
                            'assets/images/notification.png',
                            fit: BoxFit.contain,
                          )),
                    ),
                    Text(
                      'Are you sure you want to delete this track ? ',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        deleteDown(id);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.9],
                              colors: [
                                Color(0xFF7E2BF5),
                                Color(0xFF3741AE),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Remove'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black54,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'cancel'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color(0xFF5A1DA9),
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Downloaded Musics",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEEAEFF),
                      fontSize: 16.0,
                    )),
                background: Image.asset(
                  "assets/images/bg1.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: FutureBuilder(
            future: getDownloadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.length > 0)
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          _locator.musics = snapshot.data;
                          _locator.songIndex = index;
                          Navigator.of(context)
                              .push(new MaterialPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return SinglePlayer(index: index);
                                  },
                                  fullscreenDialog: true));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: Icon(
                                              Icons.play_circle_outline,
                                              color: Color(0xFF0D47A1),
                                            ),
                                          ),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(snapshot.data[index].title,
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black)),
                                                Text(
                                                  snapshot.data[index].duration,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Color(0xFF707070)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _deleteMusic(snapshot.data[index].id),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Divider(
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                else
                  return Center(
                    child: Text(
                        'Download Tracks are Empty\n You can download the tracks for ofline use.'),
                  );
              } else
                return Center(
                  child: CupertinoActivityIndicator(),
                );
            }),
      ),
    );
  }
}
