import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class howToVideos extends StatefulWidget {
  _howToVideos createState() => _howToVideos();
}

class _howToVideos extends State<howToVideos> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'osV-Ryh4vAQ',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
    ),
  );
  YoutubePlayerController _controller1 = YoutubePlayerController(
    initialVideoId: 'AabIr_NHBms',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helping Videos"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    "HOW TO REGISTER A COMPANY IN KERALA",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20.00,
                  ),
                  child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            // some widgets
                            player,
                            //some other widgets
                          ],
                        );
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Text(
                    "How to Register Trademark in Kerala",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 20.00,
                  ),
                  child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _controller1,
                        showVideoProgressIndicator: true,
                      ),
                      builder: (context, player) {
                        return Column(
                          children: [
                            // some widgets
                            player,
                            //some other widgets
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
