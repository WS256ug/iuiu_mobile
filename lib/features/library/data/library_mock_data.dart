import '../models/library_models.dart';

/// Replaceable library categories, resources, books, and member information.
abstract final class LibraryMockData {
  static const List<LibraryCategory> categories = [
    LibraryCategory(
      id: 'all',
      name: 'All',
      description: 'All digital library resources',
    ),
    LibraryCategory(
      id: 'arua-campus',
      name: 'Arua Campus',
      description: 'Arua campus library resources',
    ),
    LibraryCategory(
      id: 'dissertations',
      name: 'Dissertations',
      description: 'Research reports and dissertations',
    ),
    LibraryCategory(
      id: 'females-campus',
      name: 'Females Campus',
      description: 'Females campus library resources',
    ),
    LibraryCategory(
      id: 'general-library',
      name: 'General Library',
      description: 'General and Islamic studies resources',
    ),
    LibraryCategory(
      id: 'law-library',
      name: 'Law Library',
      description: 'Law studies and legal reports',
    ),
    LibraryCategory(
      id: 'medical-library',
      name: 'Medical Library',
      description: 'Medical and health sciences resources',
    ),
  ];

  static const List<DigitalLibraryResource> resources = [
    DigitalLibraryResource(
      id: 'east-africa-law-reports-1957',
      title: '1957 East Africa Law Reports',
      categoryId: 'law-library',
      categoryName: 'East African Law Reports',
      uploadedOn: '17-05-2021',
      sizeLabel: '8.07 MB',
    ),
    DigitalLibraryResource(
      id: 'east-africa-law-reports-1958',
      title: '1958 East Africa Law Reports',
      categoryId: 'law-library',
      categoryName: 'East African Law Reports',
      uploadedOn: '17-05-2021',
      sizeLabel: '6.80 MB',
    ),
    DigitalLibraryResource(
      id: 'east-africa-law-reports-1959',
      title: '1959 East Africa Law Reports',
      categoryId: 'law-library',
      categoryName: 'East African Law Reports',
      uploadedOn: '17-05-2021',
      sizeLabel: '8.92 MB',
    ),
    DigitalLibraryResource(
      id: 'east-africa-law-reports-1960',
      title: '1960 East Africa Law Reports',
      categoryId: 'law-library',
      categoryName: 'East African Law Reports',
      uploadedOn: '17-05-2021',
      sizeLabel: '8.63 MB',
    ),
    DigitalLibraryResource(
      id: 'principles-islamic-jurisprudence',
      title: 'Principles of Islamic Jurisprudence',
      categoryId: 'general-library',
      categoryName: 'Sharia and Islamic Studies',
      uploadedOn: '10-08-2022',
      sizeLabel: '2.75 MB',
    ),
    DigitalLibraryResource(
      id: 'introduction-public-health',
      title: 'Introduction to Public Health',
      categoryId: 'medical-library',
      categoryName: 'Health Sciences',
      uploadedOn: '04-02-2024',
      sizeLabel: '4.20 MB',
    ),
    DigitalLibraryResource(
      id: 'research-methods-dissertation',
      title: 'Research Methods for Undergraduate Dissertations',
      categoryId: 'dissertations',
      categoryName: 'Research and Dissertations',
      uploadedOn: '22-01-2025',
      sizeLabel: '3.14 MB',
    ),
    DigitalLibraryResource(
      id: 'arua-community-development',
      title: 'Community Development in Northern Uganda',
      categoryId: 'arua-campus',
      categoryName: 'Development Studies',
      uploadedOn: '12-06-2024',
      sizeLabel: '2.90 MB',
    ),
    DigitalLibraryResource(
      id: 'women-leadership',
      title: 'Women, Education and Leadership',
      categoryId: 'females-campus',
      categoryName: 'Social Sciences',
      uploadedOn: '18-09-2024',
      sizeLabel: '1.86 MB',
    ),
  ];

  static const List<CatalogBook> catalog = [
    CatalogBook(
      id: 'catalog-clean-code',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      callNumber: '005.1 MAR',
      library: 'General Library',
      isAvailable: true,
    ),
    CatalogBook(
      id: 'catalog-database-systems',
      title: 'Database System Concepts',
      author: 'Abraham Silberschatz',
      callNumber: '005.74 SIL',
      library: 'General Library',
      isAvailable: false,
    ),
    CatalogBook(
      id: 'catalog-constitutional-law',
      title: 'Constitutional Law of Uganda',
      author: 'B. J. Odoki',
      callNumber: '342.676 ODO',
      library: 'Law Library',
      isAvailable: true,
    ),
    CatalogBook(
      id: 'catalog-medical-physiology',
      title: 'Textbook of Medical Physiology',
      author: 'John E. Hall',
      callNumber: '612 HAL',
      library: 'Medical Library',
      isAvailable: true,
    ),
  ];

  static const LibraryProfile profile = LibraryProfile(
    memberName: 'Wasswa Swalleh',
    memberId: '223-063012-25992',
    homeLibrary: 'Kampala Campus · General Library',
    status: 'Active',
    outstandingFine: 0,
    borrowedBooks: [
      BorrowedBook(
        id: 'borrowed-networking',
        title: 'Computer Networks',
        borrowedOn: '18 July 2026',
        dueOn: '08 August 2026',
      ),
      BorrowedBook(
        id: 'borrowed-business-intelligence',
        title: 'Business Intelligence Guidebook',
        borrowedOn: '22 July 2026',
        dueOn: '12 August 2026',
      ),
    ],
  );
}
