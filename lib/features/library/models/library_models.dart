/// Names the three library areas available from the destination sheet.
enum LibraryDestination { profile, digitalLibrary, catalog }

/// Describes one subject group in the digital library.
class LibraryCategory {
  const LibraryCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}

/// Stores the title, category, date, and size of one downloadable resource.
class DigitalLibraryResource {
  const DigitalLibraryResource({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.uploadedOn,
    required this.sizeLabel,
  });

  final String id;
  final String title;
  final String categoryId;
  final String categoryName;
  final String uploadedOn;
  final String sizeLabel;
}

/// Stores the searchable catalogue details and availability of one book.
class CatalogBook {
  const CatalogBook({
    required this.id,
    required this.title,
    required this.author,
    required this.callNumber,
    required this.library,
    required this.isAvailable,
  });

  final String id;
  final String title;
  final String author;
  final String callNumber;
  final String library;
  final bool isAvailable;
}

/// Stores the borrowing and due dates for one checked-out book.
class BorrowedBook {
  const BorrowedBook({
    required this.id,
    required this.title,
    required this.borrowedOn,
    required this.dueOn,
  });

  final String id;
  final String title;
  final String borrowedOn;
  final String dueOn;
}

/// Groups a member's library status, balance, and borrowed books.
class LibraryProfile {
  const LibraryProfile({
    required this.memberName,
    required this.memberId,
    required this.homeLibrary,
    required this.status,
    required this.outstandingFine,
    required this.borrowedBooks,
  });

  final String memberName;
  final String memberId;
  final String homeLibrary;
  final String status;
  final int outstandingFine;
  final List<BorrowedBook> borrowedBooks;
}
