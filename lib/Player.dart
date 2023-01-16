import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer1/Songs.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatefulWidget {
  Player({Key? key, required this.index, required this.audioplayer})
      : super(key: key);
  int index;
  AudioPlayer audioplayer;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  int? _duration;
  int? _position;
  String? Uuri;
  SongModel? songdata;
  int? Index;
  bool a = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  playSong() {
    Index = widget.index;
    songdata = Songs.lst![Index!];
    print(
        '??????????????????????????????????????????????????????????????${songdata}');
    Uuri = songdata!.uri!;
    try {
      widget.audioplayer.setAudioSource(AudioSource.uri(Uri.parse(Uuri!)));
      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      widget.audioplayer.play();
      setState(() {
        a = true;
      });

      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      _duration = songdata!.duration;
    } catch (e) {
      print(e);
    }
  }
  prevSong(){
    Index = Index! -1;
    songdata = Songs.lst![Index!];
    Uuri = songdata!.uri!;
    try {
      widget.audioplayer.setAudioSource(AudioSource.uri(Uri.parse(Uuri!)));
      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      widget.audioplayer.play();
      setState(() {
        a = true;
      });
      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      _duration = songdata!.duration;
    } catch (e) {
      print(e);
    }
  }

  nextSong() {
    Index = Index! + 1;
    songdata = Songs.lst![Index!];
    Uuri = songdata!.uri!;
    try {
      widget.audioplayer.setAudioSource(AudioSource.uri(Uri.parse(Uuri!)));
      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      widget.audioplayer.play();
      setState(() {
        a = true;
      });
      print('>>>>>>>>>>>${widget.audioplayer.playing}');
      _duration = songdata!.duration;
    } catch (e) {
      print(e);
    }
  }

  playerState(snapshot) async {
    if (snapshot.data?.processingState == ProcessingState.completed) {
      a = false;
      Future.delayed(Duration(seconds: 1), nextSong);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double h = size.height - 90;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            songdata!.displayNameWOExt.toString(),
          ),
          elevation: 20),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
                left: size.width - (size.width - 45),
                top: h - (h - 90),
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  height: size.width - 80,
                  width: size.width - 80,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                      color: Colors.white),
                  child: QueryArtworkWidget(
                      id: songdata!.id,
                      type: ArtworkType.AUDIO,
                      artworkBlendMode: BlendMode.lighten,
                      nullArtworkWidget: Icon(Icons.music_note)),
                )),
            Positioned(
                top: h - 240,
                child: SizedBox(
                    width: size.width - 20,
                    child: Text(
                      songdata!.displayNameWOExt.toString(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ))),
            Positioned(
                top: h - 180,
                child: SizedBox(
                    width: size.width - 10,
                    child: StreamBuilder<Duration>(
                      stream: widget.audioplayer.positionStream,
                      builder: (context, AsyncSnapshot<Duration> snapshot) {
                        _position =
                            widget.audioplayer.position.inSeconds.toInt();
                        return Slider(
                          value: snapshot.data?.inSeconds.toDouble() ?? 0,
                          min: 0,
                          max: songdata!.duration!.toDouble() / 1000,
                          onChanged: (value) {
                            setState(() {
                              widget.audioplayer
                                  .seek(Duration(seconds: value.toInt()));
                            });
                          },
                        );
                      },
                    ))),
            Positioned(
                top: h - 120,
                child: SizedBox(
                  width: size.width,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: IconButton(
                            onPressed: () {
                              prevSong();
                            },
                            icon: Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: IconButton(
                          onPressed: () {
                            widget.audioplayer
                                .seek(Duration(seconds: _position! - 5));
                          },
                          icon: const Icon(
                            size: 30,
                            Icons.fast_rewind,
                            color: Colors.white,
                          ),
                        ),
                      ),SizedBox(width: 20),
                      StreamBuilder(
                          stream: widget.audioplayer.playerStateStream,
                          builder:
                              (context, AsyncSnapshot<PlayerState> snapshot) {
                            print('???????????????/${snapshot.data}');
                            playerState(snapshot);

                            return a
                                ? Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.audioplayer.pause();
                                            a = false;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.pause,
                                          size: 50,
                                          color: Colors.black,
                                        )),
                                  )
                                : Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.audioplayer.play();
                                          a = true;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.black,
                                        size: 50,
                                      ),
                                    ),
                                  );
                          }),SizedBox(width: 20),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: IconButton(
                          onPressed: () {
                            widget.audioplayer
                                .seek(Duration(seconds: _position! + 5));
                          },
                          icon: Icon(
                            Icons.fast_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(60))),
                        child: IconButton(
                            onPressed: () {nextSong();},
                            icon: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 25,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
