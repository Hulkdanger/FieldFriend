// Automatic FlutterFlow imports
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import '/actions/actions.dart' as action_blocks;
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomFeedbackWidget extends StatefulWidget {
  const CustomFeedbackWidget({
    Key? key,
    this.width,
    this.height,
    this.collectionName = 'feedback',
    this.emailHintText = 'Enter your email',
    this.concernsHintText = 'Share your concerns (max 100 words)',
    this.submitButtonText = 'Submit',
    this.successMessage = 'Thank you! Your feedback has been submitted.',
    this.errorMessage = 'An error occurred. Please try again.',
  }) : super(key: key);

  final double? width;
  final double? height;
  final String collectionName;
  final String emailHintText;
  final String concernsHintText;
  final String submitButtonText;
  final String successMessage;
  final String errorMessage;

  @override
  State<CustomFeedbackWidget> createState() => _CustomFeedbackWidgetState();
}

class _CustomFeedbackWidgetState extends State<CustomFeedbackWidget> {
  final _emailController = TextEditingController();
  final _concernsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool _isSubmitting = false;
  int _wordCount = 0;
  static const int _maxWords = 100;

  @override
  void initState() {
    super.initState();
    _concernsController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _concernsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    final text = _concernsController.text.trim();
    final words = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    setState(() {
      _wordCount = words;
    });
  }

  int _getWordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateConcerns(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your concerns';
    }
    final wordCount = _getWordCount(value);
    if (wordCount > _maxWords) {
      return 'Please limit to $_maxWords words (currently $wordCount)';
    }
    return null;
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection(widget.collectionName).add({
        'email': _emailController.text.trim(),
        'concerns': _concernsController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.successMessage),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        _emailController.clear();
        _concernsController.clear();
        setState(() {
          _wordCount = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // COMPLETELY SIMPLIFIED LAYOUT - NO COMPLEX CONSTRAINTS OR LAYOUTS
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 13),
                  hintText: widget.emailHintText,
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6), fontSize: 13),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Colors.black, size: 20),
                  filled: true,
                  fillColor: Colors.grey[50],
                  isDense: true,
                ),
                validator: _validateEmail,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),

              // Concerns Field
              TextFormField(
                controller: _concernsController,
                maxLines: 4,
                minLines: 4,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Concerns',
                  alignLabelWithHint: true,
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 13),
                  hintText: widget.concernsHintText,
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6), fontSize: 13),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.comment_outlined,
                        color: Colors.black, size: 20),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  counterText: '$_wordCount / $_maxWords words',
                  counterStyle: TextStyle(
                    color: _wordCount > _maxWords
                        ? Colors.red
                        : Colors.black.withOpacity(0.7),
                    fontSize: 11,
                  ),
                  isDense: true,
                ),
                validator: _validateConcerns,
                enabled: !_isSubmitting,
              ),
              const SizedBox(height: 16),

              // Submit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            widget.submitButtonText,
                            style: const TextStyle(fontSize: 14),
                          ),
                  ),
                ],
              ),

              // Bottom padding
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
