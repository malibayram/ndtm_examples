import 'package:flutter/material.dart';

import '../../utils/file_size_converter.dart';

abstract class IFile {
  int getSize();
  Widget render(BuildContext context);
  String accept(IVisitor visitor);
}

abstract class File extends StatelessWidget implements IFile {
  final String title;
  final String fileExtension;
  final int size;
  final IconData icon;

  const File({
    super.key,
    required this.title,
    required this.fileExtension,
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
          '$title.$fileExtension',
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
  final String albumTitle;

  const AudioFile({
    super.key,
    super.icon = Icons.music_note,
    required this.albumTitle,
    required super.title,
    required super.fileExtension,
    required super.size,
  });

  @override
  String accept(IVisitor visitor) {
    return visitor.visitAudioFile(this);
  }
}

class ImageFile extends File {
  final String resolution;

  const ImageFile({
    super.key,
    super.icon = Icons.image,
    required this.resolution,
    required super.title,
    required super.fileExtension,
    required super.size,
  });

  @override
  String accept(IVisitor visitor) {
    return visitor.visitImageFile(this);
  }
}

class TextFile extends File {
  final String content;

  const TextFile({
    super.key,
    super.icon = Icons.description,
    required this.content,
    required super.title,
    required super.fileExtension,
    required super.size,
  });

  @override
  String accept(IVisitor visitor) {
    return visitor.visitTextFile(this);
  }
}

class VideoFile extends File {
  final String directedBy;

  const VideoFile({
    super.key,
    super.icon = Icons.movie,
    required this.directedBy,
    required super.title,
    required super.fileExtension,
    required super.size,
  });

  @override
  String accept(IVisitor visitor) {
    return visitor.visitVideoFile(this);
  }
}

class Directory extends StatelessWidget implements IFile {
  final String title;
  final int level;
  final bool isInitiallyExpanded;

  final List<IFile> _files = [];
  List<IFile> get files => _files;

  Directory({
    super.key,
    required this.title,
    required this.level,
    this.isInitiallyExpanded = false,
  });

  void addFile(IFile file) {
    _files.add(file);
  }

  @override
  int getSize() {
    var sum = 0;

    for (final file in _files) {
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
          children: _files.map((IFile file) => file.render(context)).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  @override
  String accept(IVisitor visitor) {
    return visitor.visitDirectory(this);
  }
}

extension FormattingExtension on String {
  String indentAndAddNewLine(int nTabs) => '${'\t' * nTabs}$this\n';
}

abstract class IVisitor {
  String getTitle();
  String visitDirectory(Directory directory);
  String visitAudioFile(AudioFile file);
  String visitImageFile(ImageFile file);
  String visitTextFile(TextFile file);
  String visitVideoFile(VideoFile file);
}

class HumanReadableVisitor implements IVisitor {
  @override
  String getTitle() => 'Export as text';

  @override
  String visitAudioFile(AudioFile file) {
    final fileInfo = <String, String>{
      'Type': 'Audio',
      'Album': file.albumTitle,
      'Extension': file.fileExtension,
      'Size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile(file.title, fileInfo);
  }

  @override
  String visitDirectory(Directory directory) {
    final buffer = StringBuffer();

    for (final file in directory.files) {
      buffer.write(file.accept(this));
    }

    return buffer.toString();
  }

  @override
  String visitImageFile(ImageFile file) {
    final fileInfo = <String, String>{
      'Type': 'Image',
      'Resolution': file.resolution,
      'Extension': file.fileExtension,
      'Size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile(file.title, fileInfo);
  }

  @override
  String visitTextFile(TextFile file) {
    final fileContentPreview = file.content.length > 30
        ? '${file.content.substring(0, 30)}...'
        : file.content;

    final fileInfo = <String, String>{
      'Type': 'Text',
      'Preview': fileContentPreview,
      'Extension': file.fileExtension,
      'Size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile(file.title, fileInfo);
  }

  @override
  String visitVideoFile(VideoFile file) {
    final fileInfo = <String, String>{
      'Type': 'Video',
      'Directed by': file.directedBy,
      'Extension': file.fileExtension,
      'Size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile(file.title, fileInfo);
  }

  String _formatFile(String title, Map<String, String> fileInfo) {
    final buffer = StringBuffer();

    buffer.write('$title:\n');

    for (final entry in fileInfo.entries) {
      buffer.write('${entry.key}: ${entry.value}'.indentAndAddNewLine(2));
    }

    return buffer.toString();
  }
}

class XmlVisitor implements IVisitor {
  @override
  String getTitle() => 'Export as XML';

  @override
  String visitAudioFile(AudioFile file) {
    final fileInfo = <String, String>{
      'title': file.title,
      'album': file.albumTitle,
      'extension': file.fileExtension,
      'size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile('audio', fileInfo);
  }

  @override
  String visitDirectory(Directory directory) {
    final isRootDirectory = directory.level == 0;
    final buffer = StringBuffer();

    if (isRootDirectory) {
      buffer.write('<files>\n');
    }

    for (final file in directory.files) {
      buffer.write(file.accept(this));
    }

    if (isRootDirectory) {
      buffer.write('</files>\n');
    }

    return buffer.toString();
  }

  @override
  String visitImageFile(ImageFile file) {
    final fileInfo = <String, String>{
      'title': file.title,
      'resolution': file.resolution,
      'extension': file.fileExtension,
      'size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile('image', fileInfo);
  }

  @override
  String visitTextFile(TextFile file) {
    final fileContentPreview = file.content.length > 30
        ? '${file.content.substring(0, 30)}...'
        : file.content;

    final fileInfo = <String, String>{
      'title': file.title,
      'preview': fileContentPreview,
      'extension': file.fileExtension,
      'size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile('text', fileInfo);
  }

  @override
  String visitVideoFile(VideoFile file) {
    final fileInfo = <String, String>{
      'title': file.title,
      'directed_by': file.directedBy,
      'extension': file.fileExtension,
      'size': FileSizeConverter.bytesToString(file.getSize()),
    };

    return _formatFile('video', fileInfo);
  }

  String _formatFile(String type, Map<String, String> fileInfo) {
    final buffer = StringBuffer();

    buffer.write('<$type>'.indentAndAddNewLine(2));

    for (final entry in fileInfo.entries) {
      buffer.write(
        '<${entry.key}>${entry.value}</${entry.key}>'.indentAndAddNewLine(4),
      );
    }

    buffer.write('</$type>'.indentAndAddNewLine(2));

    return buffer.toString();
  }
}
