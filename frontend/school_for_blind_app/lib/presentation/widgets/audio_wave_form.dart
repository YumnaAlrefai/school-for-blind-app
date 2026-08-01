import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioWaveForm extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;
  final List<Duration> bookmarkPositions;

  const AudioWaveForm({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    required this.bookmarkPositions,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercent = 0.0;
    if (duration.inMilliseconds > 0) {
      progressPercent = position.inMilliseconds / duration.inMilliseconds;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxTrackWidth = constraints.maxWidth;

        void handleTapOrDrag(double localX) {
          if (duration.inMilliseconds <= 0 || maxTrackWidth <= 0) return;
          double percent = localX / maxTrackWidth;
          percent = percent.clamp(0.0, 1.0);
          final milliseconds = (percent * duration.inMilliseconds).toInt();
          onSeek(Duration(milliseconds: milliseconds));
        }

        return GestureDetector(
          onTapDown: (details) => handleTapOrDrag(details.localPosition.dx),
          onPanUpdate: (details) => handleTapOrDrag(details.localPosition.dx),
          child: Container(
            width: double.infinity,
            height: 200.h,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(45, (index) {
                      final heights = [
                        20.h,
                        40.h,
                        15.h,
                        30.h,
                        55.h,
                        70.h,
                        45.h,
                        20.h,
                        35.h,
                        60.h,
                        80.h,
                        50.h,
                        25.h,
                        40.h,
                        65.h,
                        30.h,
                        20.h,
                        55.h,
                        75.h,
                        40.h,
                        15.h,
                        30.h,
                        60.h,
                        85.h,
                        50.h,
                        20.h,
                        45.h,
                        70.h,
                        35.h,
                        25.h,
                        55.h,
                        80.h,
                        40.h,
                        15.h,
                        30.h,
                        65.h,
                        45.h,
                        20.h,
                        35.h,
                        50.h,
                        75.h,
                        40.h,
                        20.h,
                        30.h,
                        15.h,
                      ];
                      return Container(
                        width: 3.w,
                        height: heights[index % heights.length],
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),

                if (duration.inMilliseconds > 0)
                  ...bookmarkPositions.map((bookmarkTime) {
                    double bookmarkPercent =
                        bookmarkTime.inMilliseconds / duration.inMilliseconds;
                    double xPosition = bookmarkPercent * maxTrackWidth;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: xPosition,
                          top: 0.h,
                          bottom: 0,
                          child: Container(
                            width: 2.5.w,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Positioned(
                          left: xPosition - 0.2.w,
                          top: -19.5,
                          child: FaIcon(
                            FontAwesomeIcons.solidFlag,
                            color: Theme.of(context).colorScheme.primary,
                            size: 23.r,
                          ),
                        ),
                      ],
                    );
                  }),
                Positioned(
                  left: progressPercent * maxTrackWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 2.5.w,
                    color: const Color(0xFFFf3333),
                  ),
                ),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.2),
                  thickness: 1,
                  height: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
