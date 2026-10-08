/// `GET /astro/onboarding/kyc`: what the astrologer is asked for and where each
/// part of their application stands. Which documents are asked for is set by
/// the team in admin, so nothing here names a document.
class KycStatus {
  const KycStatus({
    required this.stage,
    required this.documents,
    required this.bank,
    required this.interviewRequired,
    required this.interview,
  });

  /// While under review: `documents`, `interview` or `decision`.
  final String stage;
  final List<KycDocumentState> documents;
  final KycBank? bank;
  final bool interviewRequired;
  final KycInterview? interview;

  /// Documents the astrologer has to do something about.
  List<KycDocumentState> get actionable => [
    for (final d in documents)
      if (d.rejected || (d.missing && d.required)) d,
  ];

  factory KycStatus.fromJson(Map<String, dynamic> j) => KycStatus(
    stage: j['stage'] as String? ?? 'documents',
    documents: [
      for (final d in j['documents'] as List? ?? const [])
        KycDocumentState.fromJson((d as Map).cast<String, dynamic>()),
    ],
    bank: j['bank'] is Map
        ? KycBank.fromJson((j['bank'] as Map).cast<String, dynamic>())
        : null,
    interviewRequired: j['interview_required'] != false,
    interview: j['interview'] is Map
        ? KycInterview.fromJson((j['interview'] as Map).cast<String, dynamic>())
        : null,
  );
}

class KycDocumentState {
  const KycDocumentState({
    required this.docType,
    required this.title,
    required this.help,
    required this.required,
    required this.needsFile,
    required this.needsNumber,
    required this.status,
    required this.hasFile,
    required this.numberLast4,
    required this.note,
  });

  final String docType;
  final String title;
  final String help;
  final bool required;
  final bool needsFile;
  final bool needsNumber;

  /// `missing`, `pending`, `verified`, `rejected` (or the vendor's
  /// `submitted` / `manual_review`, which read as pending).
  final String status;
  final bool hasFile;
  final String numberLast4;

  /// Why a reviewer sent it back, when they did.
  final String note;

  bool get missing => status == 'missing';
  bool get rejected => status == 'rejected';
  bool get verified => status == 'verified';

  factory KycDocumentState.fromJson(Map<String, dynamic> j) => KycDocumentState(
    docType: j['doc_type'] as String? ?? '',
    title: j['title'] as String? ?? '',
    help: j['help'] as String? ?? '',
    required: j['required'] == true,
    needsFile: j['needs_file'] == true,
    needsNumber: j['needs_number'] == true,
    status: j['status'] as String? ?? 'missing',
    hasFile: j['has_file'] == true,
    numberLast4: j['number_last4'] as String? ?? '',
    note: j['note'] as String? ?? '',
  );
}

class KycBank {
  const KycBank({
    required this.status,
    required this.last4,
    required this.note,
  });

  final String status;
  final String last4;

  /// Why a reviewer sent the details back, when they did.
  final String note;

  bool get rejected => status == 'rejected';

  factory KycBank.fromJson(Map<String, dynamic> j) => KycBank(
    status: j['status'] as String? ?? 'pending',
    last4: j['account_number_last4'] as String? ?? '',
    note: j['note'] as String? ?? '',
  );
}

class KycInterview {
  const KycInterview({
    required this.status,
    required this.scheduledAt,
    required this.mode,
    required this.meetingLink,
  });

  /// `scheduled`, `passed`, `failed`, `no_show`, `skipped`.
  final String status;

  /// Local time.
  final DateTime? scheduledAt;

  /// `phone`, `whatsapp` or `video_link`.
  final String mode;
  final String meetingLink;

  bool get scheduled => status == 'scheduled';
  bool get cleared => status == 'passed' || status == 'skipped';

  factory KycInterview.fromJson(Map<String, dynamic> j) => KycInterview(
    status: j['status'] as String? ?? '',
    scheduledAt: DateTime.tryParse('${j['scheduled_at']}')?.toLocal(),
    mode: j['mode'] as String? ?? 'phone',
    meetingLink: j['meeting_link'] as String? ?? '',
  );
}
