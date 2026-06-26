import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/announcements_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/announcement.dart';
import 'package:school_for_blind_app/presentation/widgets/announcement_card.dart';

class StudentAnnouncementsScreen extends StatelessWidget {
  const StudentAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ بنستخدم Builder هون عشان يعطينا "context" جديد تحت الـ Provider دغري
    return Builder(
      builder: (innerContext) {
        // 2️⃣ هون بنستدعي الدالة بقلب الـ build بأمان باستخدام الـ innerContext الجديد
        innerContext.read<AnnouncementsCubit>().emitGetAllAnnouncements();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إعلانات المدرسة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.indigo,
          ),
          body: Column(
            children: [
              // 🔍 حقل البحث
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (query) {
                    // ⚠️ تذكرّي تستخدمي innerContext هون كمان
                    innerContext.read<AnnouncementsCubit>().searchAnnouncement(
                      query,
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث عن إعلان...',
                    prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              // 📜 قائمة الإعلانات
              Expanded(
                child: BlocBuilder<AnnouncementsCubit, ResultState<dynamic>>(
                  // ⚠️ تذكرّي نمرر الـ innerContext للـ BlocBuilder عشان يعرف وين الـ Cubit
                  bloc: innerContext.read<AnnouncementsCubit>(),
                  builder: (context, state) {
                    return state.when(
                      idle: () => const Center(child: Text('ابدأ البحث')),
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.indigo),
                      ),
                      success: (data) {
                        final List<Announcement> list = List<Announcement>.from(
                          data,
                        );
                        if (list.isEmpty)
                          return const Center(child: Text('لا توجد إعلانات'));

                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                              AnnouncementCard(announcement: list[index]),
                        );
                      },
                      failure: (error) =>
                          const Center(child: Text('حدث خطأ 😢')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
