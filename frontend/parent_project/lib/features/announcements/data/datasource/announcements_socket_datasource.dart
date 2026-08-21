import '../../../../core/sockets/reverb_socket_client.dart';
import '../models/announcement_model.dart';

/// طبقة بيانات موازية للـ REST DataSource، مخصصة للاستماع اللحظي
/// (Real-time) لقناة إعلانات الـ caregiver عبر Reverb.
class AnnouncementsSocketDataSource {
  static const String _channelName = 'announcements.caregiver';

  void listenToAnnouncements(
    void Function(AnnouncementModel announcement) onNewAnnouncement,
  ) {
    ReverbSocketClient.instance.connect();
    ReverbSocketClient.instance.subscribe(_channelName, (data) {
      try {
        final model = AnnouncementModel.fromJson(data);
        onNewAnnouncement(model);
      } catch (e) {
        print("SOCKET PARSE ERROR: $e");
      }
    });
  }

  void stopListening() {
    ReverbSocketClient.instance.unsubscribe(_channelName);
  }
}