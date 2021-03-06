import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:provider/provider.dart';

class Recomended extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adstate = Provider.of<AdsProvider>(context);
    final startupProvider = Provider.of<StartupProvider>(context);
    // final musicProvider = Provider.of<MusicProvider>(context);

    void openDialog(index) {
      if (startupProvider.userdata.paid != true) adstate.showinterestialAds();
      Navigator.of(context).push(
        new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SinglePlayer(index: index);
          },
          fullscreenDialog: true,
        ),
      );
    }

    return Consumer<MusicProvider>(
        // stream: null,
        builder: (context, data, _) {
      return Container(
        // padding: const EdgeInsets.all(15.0),
        height: 320 + 25.0,
        child: data.recomended.isNotEmpty
            ? GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                scrollDirection: Axis.horizontal,
                children: List.generate(data.recomended.length, (index) {
                  return InkWell(
                    onTap: () {
                      // musicProvider.tracks = musicProvider.recomended;
                      locator<MusicService>().musics = data.recomended;
                      locator<MusicService>().songIndex = index;
                      openDialog(index);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      data.recomended[index].image),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 160.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 160.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.4, 0.9],
                              colors: [
                                Color(0x114025B2),
                                Color(0xBB6619A5),
                              ],
                            ),
                          ),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data.recomended[index].title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        )
                      ],
                    ),
                  );
                }),
              )
            : Container(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
      );
    });
  }
}
