import 'dart:io';

import 'package:flutter/material.dart';

class ThumNailHelper {
  static Widget buildThumbnail(String url) {
    // Correct local file detection
    final isLocal = url.startsWith("/storage/") || url.startsWith("/data/");

    // Create full network URL
    final fullUrl = isLocal ? url : "http://51.20.212.163:8906$url";

    // Extract extension
    final ext = url.split('.').last.toLowerCase();

    // Image extensions
    final isImage = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);

    // -------------------------
    // CASE 1: IMAGE
    // -------------------------
    if (isImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: isLocal
            ? Image.file(File(url), width: 40, height: 40, fit: BoxFit.cover)
            : Image.network(fullUrl, width: 40, height: 40, fit: BoxFit.cover),
      );
    }

    // -------------------------
    // CASE 2: DOCUMENT ICONS
    // -------------------------
    IconData icon;

    if (ext == "pdf") {
      icon = Icons.picture_as_pdf;
    } else if (ext == "doc" || ext == "docx") {
      icon = Icons.description;
    } else if (ext == "xls" || ext == "xlsx") {
      icon = Icons.table_chart;
    } else if (ext == "txt" || ext == "csv") {
      icon = Icons.notes;
    } else {
      icon = Icons.insert_drive_file;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
      ),
      child: Icon(icon, color: Colors.black54, size: 24),
    );
  }
}
