import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/channels_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/channel_model.dart';
import 'package:school_for_blind_app/presentation/widgets/chat_card.dart';
import 'package:school_for_blind_app/presentation/widgets/secondary_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';

class StudentChatsScreen extends StatelessWidget {
  const StudentChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChannelsCubit>()..getAllChannels(),
      child: const _StudentChatsContent(),
    );
  }
}

class _StudentChatsContent extends StatefulWidget {
  const _StudentChatsContent();

  @override
  State<_StudentChatsContent> createState() => _StudentChatsContentState();
}

class _StudentChatsContentState extends State<_StudentChatsContent> {
  int _selectedTabIndex = 0;

  Future<void> _refreshChannels() async {
    context.read<ChannelsCubit>().getAllChannels();
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leadingWidth: 100.w,
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          ' الدردشات',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 48,
          ),
        ),
        actions: [
          SmallButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {
              getIt<VoiceServices>().speak('');
            },
          ),
          SizedBox(width: 20.w),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildToggleTabs(),
          SizedBox(height: 20.w),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshChannels,
              color: Theme.of(context).colorScheme.primary,
              child: BlocBuilder<ChannelsCubit, ResultState<ChannelsResponse>>(
                builder: (context, state) {
                  return state.when(
                    idle: () => const SizedBox.shrink(),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    failure: (networkException) {
                      getIt<VoiceServices>().speak('حدث خطأ');
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [SizedBox(height: 150.h)],
                      );
                    },
                    success: (channelsResponse) {
                      final channels = channelsResponse.data;

                      if (channels.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 200.h),
                            Center(
                              child: Text(
                                'لا يوجد محادثات حالياً',
                                style: AppTextStyles.kMediumPrimary(context),
                              ),
                            ),
                          ],
                        );
                      }

                      return _selectedTabIndex == 0
                          ? _buildChannelsList(channels)
                          : _buildDiscussionsList(channels);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SecondaryTabs(
          label: 'القنوات',
          isSelected: _selectedTabIndex == 0,
          onPressed: () => setState(() => _selectedTabIndex = 0),
        ),
        SizedBox(width: 20.w),
        SecondaryTabs(
          label: 'المجموعات',
          isSelected: _selectedTabIndex == 1,
          onPressed: () => setState(() => _selectedTabIndex = 1),
        ),
      ],
    );
  }

  Widget _buildChannelsList(List<ChannelModel> channels) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        final title = channel.subject?.name ?? channel.name;

        return ChatCard(
          title: title,
          icon: getChannelIcon(title),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.kStudentMessagesScreen,
              arguments: {
                'channelId': channel.id,
                'channelName': title,
                'currentUserId':
                    context.read<StudentCubit>().currentStudent?.id ?? 302,
                'icon': getChannelIcon(title),
                'isChannel': true,
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDiscussionsList(List<ChannelModel> channels) {
    final discussions = channels
        .where((item) => item.discussion != null)
        .map((item) => item.discussion!)
        .toList();

    if (discussions.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 200.h),
          Center(
            child: Text(
              'لا توجد مجموعات مناقشة حالياً',
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: discussions.length,
      itemBuilder: (context, index) {
        final discussion = discussions[index];
        return ChatCard(
          title: discussion.name,
          icon: Icons.group,
          hasNotification: true,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.kStudentMessagesScreen,
              arguments: {
                'channelId': discussion.id,
                'channelName': discussion.name,
                'currentUserId':
                    context.read<StudentCubit>().currentStudent?.id ?? 1372,
                "icon": Icons.group,
                'isChannel': false,
              },
            );
          },
        );
      },
    );
  }

  final Map<String, IconData> subjectIcons = {
    'الفلسفة': Icons.psychology,
    'التاريخ': Icons.history_edu,
    'الجغرافيا': Icons.public,
    'اللغة العربية': Icons.auto_stories,
    'اللغة الإنكليزية': Icons.translate,
    'اللغة الفرنسية': Icons.language,
    'التربية الدينية': Icons.mosque,
    'الرياضيات': Icons.functions,
    'الفيزياء والكيمياء': Icons.science,
    'علم الأحياء والأرض': Icons.biotech,
  };

  IconData getChannelIcon(String channelName) {
    for (var entry in subjectIcons.entries) {
      if (channelName.contains(entry.key)) {
        return entry.value;
      }
    }
    return Icons.announcement;
  }
}
