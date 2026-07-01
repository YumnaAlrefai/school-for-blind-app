import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';

class AudioBookmarksList extends StatelessWidget {
  final List<AudioBookmark> bookmarks;
  final Function(int) onDelete;
  final Function(Duration) onBookmarkTap;
  final VoidCallback
  onStateChanged;
  final String Function(Duration) formatDuration;

  const AudioBookmarksList({
    super.key,
    required this.bookmarks,
    required this.onDelete,
    required this.onBookmarkTap,
    required this.onStateChanged,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return Container(
        height: 200.h,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        child: Text(
          "لا يوجد علامات مضافة",
          style: AppTextStyles.kMediumPrimary(context),
        ),
      );
    }

    return Container(
      height: 200.h,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = bookmarks[index];
          return Row(
            children: [
              IconButton(
                onPressed: () => onDelete(index),
                icon: const Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.onBackground,
                iconSize: 32,
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () => onBookmarkTap(bookmark.position),
                child: Text(
                  formatDuration(bookmark.position),
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: bookmark.isEditing
                    ? SizedBox(
                        height: 48.h,
                        child: TextField(
                          cursorHeight: 24,
                          controller: bookmark.controller,
                          autofocus: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 30,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            onStateChanged();
                            bookmark.isEditing = false;
                            bookmark.title =
                                bookmark.controller.text.trim().isNotEmpty
                                ? bookmark.controller.text.trim()
                                : "";
                          },
                          onSubmitted: (value) {
                            onStateChanged();
                            bookmark.isEditing = false;
                            bookmark.title = value.trim().isNotEmpty
                                ? value.trim()
                                : "";
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          onStateChanged();
                          bookmark.isEditing = true;
                        },
                        child: Container(
                          height: 48.h,
                          decoration:
                              bookmark.title != null &&
                                  bookmark.title!.isNotEmpty
                              ? BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                )
                              : BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                          child: Center(
                            child:
                                bookmark.title != null &&
                                    bookmark.title!.isNotEmpty
                                ? Text(
                                    bookmark.title!,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onBackground,
                                      fontSize: 30,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        size: 25,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "إضافة ملاحظة",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
