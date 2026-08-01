import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

Future<void> showAttachmentOptions({
  required BuildContext context,
  required Function(ImageSource src) pickImage,
  required Function() pickAudio,
}) async {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).colorScheme.surface,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'الكاميرا',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 40.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              Divider(color: Theme.of(context).colorScheme.onBackground),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'المعرض',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 40.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              Divider(color: Theme.of(context).colorScheme.onBackground),
              ListTile(
                leading: Icon(
                  Icons.audio_file_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'ملف صوتي',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 40.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickAudio();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> pickImageAttachment({
  required ImageSource source,
  required Function(File file, String type) onPick,
}) async {
  final picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: source, imageQuality: 80);

  if (image != null) {
    onPick(File(image.path), 'image');
  }
}

Future<void> pickAudioAttachment({
  required Function(File file, String type) onPick,
}) async {
  final result = await FilePicker.platform.pickFiles(type: FileType.audio);
  if (result != null && result.files.single.path != null) {
    onPick(File(result.files.single.path!), 'voice');
  }
}

Widget buildAttachmentPreview({
  required File file,
  required String type,
  required Function() remove,
  required BuildContext context,
}) {
  return Container(
    color: Theme.of(context).colorScheme.surface,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    child: Row(
      children: [
        Icon(
          type == 'voice'
              ? Icons.mic
              : (type == 'image' ? Icons.image : Icons.insert_drive_file),
          color: Theme.of(context).colorScheme.primary,
          size: 35.sp,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            file.path.split('/').last,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 32.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        IconButton(
          icon: Icon(Icons.close, color: Color(0xffff3333), size: 35.sp),
          onPressed: remove,
        ),
      ],
    ),
  );
}

Widget buildMessageInputField({
  required TextEditingController controller,
  required File? selectedAttachment,
  required String? attachmentType,
  required Function() sendMessage,
  required Function() startRecording,
  required Function() showAttachmentOptions,
  required BuildContext context,
  required ColorScheme colorScheme,
}) {
  final hasContent =
      controller.text.trim().isNotEmpty || selectedAttachment != null;

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
    color: colorScheme.background,
    child: SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file_rounded,
              color: colorScheme.primary,
              size: 35.sp,
            ),
            onPressed: showAttachmentOptions,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 32.sp),
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 32.sp,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.r),
                  borderSide: BorderSide.none,
                ),
              ),
              cursorHeight: 35.h,
            ),
          ),
          SizedBox(width: 10.w),
          CircleAvatar(
            backgroundColor: colorScheme.primary,
            child: IconButton(
              padding: EdgeInsets.all(2.w),
              icon: Icon(
                hasContent ? Icons.send_rounded : Icons.mic,
                color: colorScheme.onPrimary,
                size: 30.sp,
              ),
              onPressed: hasContent ? sendMessage : startRecording,
            ),
          ),
        ],
      ),
    ),
  );
}
