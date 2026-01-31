import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:global_trust_hub/core/constants/colors.dart';

/// ID Card Upload Widget
/// Allows users to upload front and back of their ID card
class IdCardUploadWidget extends StatefulWidget {
  final Function(IdCardData) onCardUploaded;
  final IdCardData? initialData;
  final String label;
  final bool isRequired;

  const IdCardUploadWidget({
    super.key,
    required this.onCardUploaded,
    this.initialData,
    this.label = 'ID Card Verification',
    this.isRequired = true,
  });

  @override
  State<IdCardUploadWidget> createState() => _IdCardUploadWidgetState();
}

class _IdCardUploadWidgetState extends State<IdCardUploadWidget> {
  Uint8List? _frontImage;
  Uint8List? _backImage;
  String? _frontFileName;
  String? _backFileName;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _frontImage = widget.initialData!.frontImage;
      _backImage = widget.initialData!.backImage;
      _frontFileName = widget.initialData!.frontFileName;
      _backFileName = widget.initialData!.backFileName;
    }
  }

  Future<void> _pickImage(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          if (isFront) {
            _frontImage = bytes;
            _frontFileName = image.name;
          } else {
            _backImage = bytes;
            _backFileName = image.name;
          }
        });
        _notifyChange();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _notifyChange() {
    widget.onCardUploaded(IdCardData(
      frontImage: _frontImage,
      backImage: _backImage,
      frontFileName: _frontFileName,
      backFileName: _backFileName,
    ));
  }

  void _removeImage(bool isFront) {
    setState(() {
      if (isFront) {
        _frontImage = null;
        _frontFileName = null;
      } else {
        _backImage = null;
        _backFileName = null;
      }
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Upload Cards Row
        Row(
          children: [
            // Front ID
            Expanded(
              child: _buildUploadCard(
                title: 'Front Side',
                image: _frontImage,
                fileName: _frontFileName,
                onTap: () => _pickImage(true),
                onRemove: () => _removeImage(true),
              ),
            ),
            const SizedBox(width: 12),
            // Back ID
            Expanded(
              child: _buildUploadCard(
                title: 'Back Side',
                image: _backImage,
                fileName: _backFileName,
                onTap: () => _pickImage(false),
                onRemove: () => _removeImage(false),
              ),
            ),
          ],
        ),

        // Status indicator
        const SizedBox(height: 8),
        if (_frontImage != null && _backImage != null)
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'Both sides uploaded successfully',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Please upload clear photos of both sides of your ID',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildUploadCard({
    required String title,
    required Uint8List? image,
    required String? fileName,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: image != null
              ? AppColors.success.withOpacity(0.5)
              : Colors.grey.shade300,
          width: image != null ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: image != null
          ? _buildImagePreview(title, image, fileName, onRemove)
          : _buildUploadPlaceholder(title, onTap),
    );
  }

  Widget _buildUploadPlaceholder(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to upload',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(
    String title,
    Uint8List image,
    String? fileName,
    VoidCallback onRemove,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Image.memory(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Remove button
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ID Card Data Model
class IdCardData {
  final Uint8List? frontImage;
  final Uint8List? backImage;
  final String? frontFileName;
  final String? backFileName;

  IdCardData({
    this.frontImage,
    this.backImage,
    this.frontFileName,
    this.backFileName,
  });

  bool get isComplete => frontImage != null && backImage != null;
}
