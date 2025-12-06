class GetHelpCenterModel {
  final bool isSuccess;
  final String message;
  final List<HelpItem> data;
  final dynamic errors;

  GetHelpCenterModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });

  factory GetHelpCenterModel.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return GetHelpCenterModel(
      isSuccess: m['is_success'] == true,
      message: (m['message'] ?? '') as String,
      data:
          (m['data'] as List? ?? [])
              .map((e) => HelpItem.fromJson(e as Map<String, dynamic>?))
              .toList(),
      errors: m['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'is_success': isSuccess,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
    'errors': errors,
  };
}

class HelpItem {
  final String question;
  final String answer;
  final int status;

  HelpItem({
    required this.question,
    required this.answer,
    required this.status,
  });

  factory HelpItem.fromJson(Map<String, dynamic>? json) {
    final m = json ?? const <String, dynamic>{};
    return HelpItem(
      question: (m['question'] ?? '') as String,
      answer: (m['answer'] ?? '') as String,
      status: (m['status'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'status': status,
  };
}
