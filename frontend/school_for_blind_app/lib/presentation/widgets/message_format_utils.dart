String formatDuration(Duration d) {
  final minutes = d.inMinutes.toString().padLeft(1, '0');
  final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formatTime(String rawDate) {
  try {
    final dateTime = DateTime.parse(rawDate).toLocal();
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  } catch (_) {
    return '';
  }
}
