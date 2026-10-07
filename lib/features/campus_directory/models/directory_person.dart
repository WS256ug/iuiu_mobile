/// Identifies the two groups available in the campus directory.
/// Distinguishes students from staff in directory filters and labels.
enum DirectoryPersonType { student, staff }

/// UI-facing contact information for one campus directory member.
/// Stores the public contact details shown for one directory person.
class DirectoryPerson {
  const DirectoryPerson({
    required this.id,
    required this.name,
    required this.type,
    required this.identifierLabel,
    required this.identifier,
    required this.phoneNumber,
    required this.email,
    required this.campus,
    this.subtitle,
  });

  final String id;
  final String name;
  final DirectoryPersonType type;
  final String identifierLabel;
  final String identifier;
  final String phoneNumber;
  final String email;
  final String campus;
  final String? subtitle;
}
