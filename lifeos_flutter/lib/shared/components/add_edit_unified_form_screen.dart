import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/glow_button.dart';
import '../widgets/neon_text.dart';

class AddEditUnifiedFormScreen extends StatefulWidget {
  final String title;
  final String entityName;
  final String nameLabel;
  final String nameHint;
  final String descLabel;
  final String descHint;
  final String submitText;

  final String initialName;
  final String initialDesc;

  final Widget? extraFields;

  final Function(String name, String description) onSubmit;
  final VoidCallback? onDelete;

  const AddEditUnifiedFormScreen({
    super.key,
    required this.title,
    required this.entityName,
    required this.nameLabel,
    required this.nameHint,
    required this.descLabel,
    required this.descHint,
    required this.submitText,
    this.initialName = '',
    this.initialDesc = '',
    this.extraFields,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<AddEditUnifiedFormScreen> createState() => _AddEditUnifiedFormScreenState();
}

class _AddEditUnifiedFormScreenState extends State<AddEditUnifiedFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _descController = TextEditingController(text: widget.initialDesc);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _hasError = true);
      return;
    }
    widget.onSubmit(_nameController.text.trim(), _descController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: NeonText(
          widget.title,
          color: AppTheme.textPrimary,
          glow: false,
        ),
        actions: widget.onDelete != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.neonPink),
                  onPressed: widget.onDelete,
                )
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.nameLabel, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              CustomInputField(
                controller: _nameController,
                hintText: widget.nameHint,
                onChanged: (v) {
                  if (_hasError) setState(() => _hasError = false);
                },
              ),
              if (_hasError)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text('This field is required', style: TextStyle(color: AppTheme.neonPink, fontSize: 12)),
                ),
              const SizedBox(height: 24),
              Text(widget.descLabel, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1.5)),
              const SizedBox(height: 8),
              CustomInputField(
                controller: _descController,
                hintText: widget.descHint,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              if (widget.extraFields != null) ...[
                widget.extraFields!,
                const SizedBox(height: 48),
              ] else ...[
                const SizedBox(height: 24),
              ],

              SizedBox(
                width: double.infinity,
                child: GlowButton(
                  text: widget.submitText,
                  color: AppTheme.primaryPurple,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
