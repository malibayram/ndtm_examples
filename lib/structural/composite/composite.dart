import 'package:flutter/material.dart';

import '../../utils/file_size_converter.dart';

abstract class IFile {
  int getSize();
  Widget render(BuildContext context);
}

class File extends StatelessWidget implements IFile {
  final String title;
  final int size;
  final IconData icon;

  const File({
    super.key,
    required this.title,
    required this.size,
    required this.icon,
  });

  @override
  int getSize() {
    return size;
  }

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: Icon(icon),
        trailing: Text(
          FileSizeConverter.bytesToString(size),
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.black54),
        ),
        dense: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}

class AudioFile extends File {
  const AudioFile({
    super.key,
    super.icon = Icons.music_note,
    required super.title,
    required super.size,
  });
}

class ImageFile extends File {
  const ImageFile({
    super.key,
    required super.title,
    required super.size,
  }) : super(icon: Icons.image);
}

class TextFile extends File {
  const TextFile({
    super.key,
    required super.title,
    required super.size,
  }) : super(icon: Icons.description);
}

class VideoFile extends File {
  const VideoFile({
    super.key,
    required super.title,
    required super.size,
  }) : super(icon: Icons.movie);
}

class Directory extends StatelessWidget implements IFile {
  final String title;
  final bool isInitiallyExpanded;

  final files = <IFile>[];

  Directory(this.title, {super.key, this.isInitiallyExpanded = false});

  void addFile(IFile file) {
    files.add(file);
  }

  @override
  int getSize() {
    var sum = 0;

    for (final file in files) {
      sum += file.getSize();
    }

    return sum;
  }

  @override
  Widget render(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ExpansionTile(
          leading: const Icon(Icons.folder),
          title: Text('$title (${FileSizeConverter.bytesToString(getSize())})'),
          initiallyExpanded: isInitiallyExpanded,
          children: files.map((IFile file) => file.render(context)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}
