import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart'; // Import the file_picker package


class FileSelector extends StatefulWidget {
  final ValueChanged<List<File>> onFilesSelected; // Add this line

  FileSelector({required this.onFilesSelected}); // Add this line

  @override
  _FileSelectorState createState() => _FileSelectorState();
}


class _FileSelectorState extends State<FileSelector> {
  List<File> _selectedFiles = [];
  double _containerHeight = 60; // Initial height

  void _addFile() async {
    List<File> files = await _pickFiles();
    if (files.isNotEmpty) {
      print("_selectedFiles:$_selectedFiles");
      setState(() {
        _selectedFiles.addAll(files);
        _updateContainerHeight();
        widget.onFilesSelected(_selectedFiles); // Add this line
      });
    }
  }


  Future<List<File>> _pickFiles() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return [];
    }
  }

  void _updateContainerHeight() {
    setState(() {
      _containerHeight = _selectedFiles.isNotEmpty ? 200 : 60; // Update height
    });
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _updateContainerHeight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _addFile,
            child: Text('Attach File'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(path.basename(_selectedFiles[index].path)),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _removeFile(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}