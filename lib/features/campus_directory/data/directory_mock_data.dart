import '../models/directory_person.dart';

/// Replaceable local contacts used while the directory API is unavailable.
abstract final class DirectoryMockData {
  static const List<DirectoryPerson> people = [
    DirectoryPerson(
      id: 'student-wasswa-swalleh',
      name: 'Wasswa Swalleh',
      type: DirectoryPersonType.student,
      identifierLabel: 'Registration No.',
      identifier: '223-063012-25992',
      phoneNumber: '0753304550',
      email: 'wasswaswalleh@iuiu.ac.ug',
      campus: 'Kampala Campus',
      subtitle: 'Bachelor of Information Technology',
    ),
    DirectoryPerson(
      id: 'student-aisha-namuli',
      name: 'Aisha Namuli',
      type: DirectoryPersonType.student,
      identifierLabel: 'Registration No.',
      identifier: '223-061012-18442',
      phoneNumber: '0772458190',
      email: 'aisha.namuli@iuiu.ac.ug',
      campus: 'Kampala Campus',
      subtitle: 'Bachelor of Business Administration',
    ),
    DirectoryPerson(
      id: 'student-ibrahim-kato',
      name: 'Ibrahim Kato',
      type: DirectoryPersonType.student,
      identifierLabel: 'Registration No.',
      identifier: '224-063012-30118',
      phoneNumber: '0701842276',
      email: 'ibrahim.kato@iuiu.ac.ug',
      campus: 'Kampala Campus',
      subtitle: 'Bachelor of Computer Science',
    ),
    DirectoryPerson(
      id: 'staff-wahab-ismael',
      name: 'Mr. Wahab Ismael',
      type: DirectoryPersonType.staff,
      identifierLabel: 'Staff ID',
      identifier: 'IUIU-KC-1042',
      phoneNumber: '0782210435',
      email: 'wahab.ismael@iuiu.ac.ug',
      campus: 'Kampala Campus',
      subtitle: 'Faculty of Science and Technology',
    ),
    DirectoryPerson(
      id: 'staff-sarah-nakato',
      name: 'Dr. Sarah Nakato',
      type: DirectoryPersonType.staff,
      identifierLabel: 'Staff ID',
      identifier: 'IUIU-KC-0871',
      phoneNumber: '0756124089',
      email: 'sarah.nakato@iuiu.ac.ug',
      campus: 'Kampala Campus',
      subtitle: 'Faculty of Management Studies',
    ),
  ];
}
