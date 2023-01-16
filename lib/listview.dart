import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer1/Songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Player.dart';

class Musicplayer extends StatefulWidget {
  const Musicplayer({Key? key}) : super(key: key);

  @override
  State<Musicplayer> createState() => _MusicplayerState();
}

class _MusicplayerState extends State<Musicplayer> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    RequestPermission();
  }

  RequestPermission() async {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'Music Player',
          style: GoogleFonts.abel(color: Colors.white),
        )),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL),
                builder: (context, AsyncSnapshot<List<SongModel>> snapshot) {
                  Songs.lst = snapshot.data;
                  print('>>>>>>>>>>>>>>>>>>>>>${Songs.lst}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text('No songs available'),
                      );
                    } else {
                      print(snapshot.data);
                      return Songs.lst == null
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              itemCount: Songs.lst!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Player(
                                                index: index,
                                                audioplayer: player),
                                          )),
                                      child: Container(
                                        width: size.width - 20,
                                        height: 90,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: Colors.grey),
                                        child: ListTile(
                                            leading: QueryArtworkWidget(
                                                id: Songs.lst![index].id,
                                                type: ArtworkType.AUDIO,
                                                artworkBlendMode:
                                                    BlendMode.lighten,
                                                nullArtworkWidget:
                                                    Icon(Icons.music_note)),
                                            title: Text(Songs.lst![index]
                                                .displayNameWOExt)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              });
                    }
                  }
                }),
          ),
        ));
  }
}
