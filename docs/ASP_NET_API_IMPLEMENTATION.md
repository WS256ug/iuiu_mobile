# ASP.NET Core API Implementation Plan for IUIU Mobile

## Purpose

This document defines how the current Flutter mock-data application will be
connected to an ASP.NET Core API without changing the approved user interface.

The main rule is:

> Replace mock data sources with API-backed repositories. Do not reshape screens
> around raw API responses.

The backend should target **.NET 10** and expose a versioned HTTPS API. ASP.NET
Core supports both Minimal APIs and controllers; Microsoft recommends Minimal
APIs for new HTTP API projects. For IUIU Mobile, use Minimal API route groups
organized by feature, with application services handling business rules.

Official references:

- [ASP.NET Core API approaches](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/apis?view=aspnetcore-10.0)
- [ASP.NET Core Web APIs](https://learn.microsoft.com/en-us/aspnet/core/web-api/?view=aspnetcore-10.0)
- [OpenAPI support](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/openapi/overview?view=aspnetcore-10.0)
- [JWT bearer authentication](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/configure-jwt-bearer-authentication?view=aspnetcore-10.0)
- [EF Core overview](https://learn.microsoft.com/en-us/ef/core/get-started/overview/first-app)
- [SignalR overview](https://learn.microsoft.com/en-us/aspnet/core/signalr/introduction?view=aspnetcore-10.0)

## Proposed System Shape

```text
Flutter mobile application
        |
        | HTTPS JSON API + bearer access token
        v
ASP.NET Core API
        |
        +-- Authentication and authorization
        +-- Feature application services
        +-- Entity Framework Core
        +-- SignalR chat hub
        +-- File/object storage adapter
        +-- SchoolPay/payment adapter
        |
        v
SQL Server or PostgreSQL
```

The API is responsible for authorization, validation, business rules, and data
storage. Flutter remains responsible for presentation formatting, screen state,
navigation, and the existing visual structure.

## Backend Solution Structure

Use feature folders without creating unnecessary layers:

```text
iuiu-api/
  src/
    Iuiu.Api/
      Features/
        Authentication/
        Campuses/
        Profile/
        Directory/
        Messages/
        Registration/
        Evaluations/
        Timetables/
        Results/
        Fees/
        Library/
      Common/
        Authentication/
        Errors/
        Pagination/
        Storage/
      Program.cs
      appsettings.json
    Iuiu.Domain/
      Entities/
      Enums/
    Iuiu.Infrastructure/
      Persistence/
      Identity/
      Messaging/
      Payments/
      Storage/
  tests/
    Iuiu.Api.Tests/
    Iuiu.Application.Tests/
    Iuiu.IntegrationTests/
```

Recommended dependency direction:

```text
Iuiu.Api -> Iuiu.Domain
Iuiu.Api -> Iuiu.Infrastructure
Iuiu.Infrastructure -> Iuiu.Domain
```

Do not place Entity Framework entities, HTTP request objects, or navigation
concepts in the Flutter UI models.

## Initial Project Setup

```powershell
dotnet new sln -n Iuiu
dotnet new webapi -n Iuiu.Api -f net10.0
dotnet new classlib -n Iuiu.Domain -f net10.0
dotnet new classlib -n Iuiu.Infrastructure -f net10.0
dotnet new xunit -n Iuiu.IntegrationTests -f net10.0
```

Likely packages:

```powershell
dotnet add Iuiu.Api package Microsoft.AspNetCore.OpenApi
dotnet add Iuiu.Api package Microsoft.AspNetCore.Authentication.JwtBearer
dotnet add Iuiu.Infrastructure package Microsoft.EntityFrameworkCore.SqlServer
dotnet add Iuiu.Infrastructure package Microsoft.EntityFrameworkCore.Design
dotnet add Iuiu.IntegrationTests package Microsoft.AspNetCore.Mvc.Testing
```

Use the PostgreSQL EF Core provider instead of the SQL Server provider if IUIU
selects PostgreSQL.

## API Bootstrap

A simplified `Program.cs` should establish the common platform concerns:

```csharp
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddProblemDetails();
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = builder.Configuration["Authentication:Authority"];
        options.Audience = builder.Configuration["Authentication:Audience"];
        options.RequireHttpsMetadata = true;
    });
builder.Services.AddAuthorization();
builder.Services.AddDbContext<IuiuDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("IuiuDatabase")));
builder.Services.AddSignalR();
builder.Services.AddRateLimiter(options =>
{
    // Add named policies for login, search, downloads, and general API use.
});
builder.Services.AddHealthChecks()
    .AddDbContextCheck<IuiuDbContext>();

var app = builder.Build();

app.UseExceptionHandler();
app.UseHttpsRedirection();
app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.MapGroup("/api/v1/auth").MapAuthenticationEndpoints();
app.MapGroup("/api/v1/campuses").MapCampusEndpoints();
app.MapGroup("/api/v1/profile").RequireAuthorization().MapProfileEndpoints();
app.MapGroup("/api/v1/directory").RequireAuthorization().MapDirectoryEndpoints();
app.MapGroup("/api/v1/messages").RequireAuthorization().MapMessageEndpoints();
app.MapGroup("/api/v1/registration").RequireAuthorization()
    .MapRegistrationEndpoints();
app.MapGroup("/api/v1/evaluations").RequireAuthorization()
    .MapEvaluationEndpoints();
app.MapGroup("/api/v1/timetables").RequireAuthorization()
    .MapTimetableEndpoints();
app.MapGroup("/api/v1/results").RequireAuthorization().MapResultEndpoints();
app.MapGroup("/api/v1/fees").RequireAuthorization().MapFeeEndpoints();
app.MapGroup("/api/v1/library").RequireAuthorization().MapLibraryEndpoints();

app.MapHub<ChatHub>("/hubs/chat").RequireAuthorization();
app.MapHealthChecks("/healthz");

app.Run();
```

OpenAPI should be generated from the actual endpoints and treated as the
contract used by both backend and Flutter developers. ASP.NET Core has
first-party OpenAPI document generation through
`Microsoft.AspNetCore.OpenApi`.

## Authentication Design

### Recommended approach

Use an institutional OpenID Connect/OAuth 2.0 provider if one exists. The API
should validate bearer access tokens rather than inventing its own token
format. Microsoft specifically discourages creating custom production access
tokens outside established OAuth/OIDC flows.

The mobile login form currently collects:

- Registration number or staff ID
- Password
- Campus

The identity service must resolve the identifier to a stable user ID and verify
that the account belongs to the selected campus. Do not use the visible name,
email, or registration-number text as the database primary key.

### Authentication endpoints

```text
GET    /api/v1/campuses
POST   /api/v1/auth/login
POST   /api/v1/auth/refresh
POST   /api/v1/auth/logout
POST   /api/v1/auth/forgot-password
POST   /api/v1/auth/reset-password
GET    /api/v1/profile/me
POST   /api/v1/profile/change-password
```

Example login request:

```json
{
  "identifier": "223-063012-25992",
  "password": "user-entered-password",
  "campusId": "kampala"
}
```

Example successful response:

```json
{
  "accessToken": "opaque-or-jwt-access-token",
  "expiresIn": 900,
  "refreshToken": "rotating-refresh-token",
  "user": {
    "id": "01JUSER...",
    "role": "student",
    "displayName": "Wasswa Swalleh",
    "campusId": "kampala"
  }
}
```

Security requirements:

- Enforce HTTPS in every non-local environment.
- Validate token signature, issuer, audience, and expiration.
- Use short-lived access tokens and rotating refresh tokens.
- Hash passwords using the selected identity provider or ASP.NET Core Identity;
  never store plaintext or reversible passwords.
- Rate-limit login and password-recovery endpoints.
- Return `401` for invalid authentication and `403` when an authenticated user
  lacks permission.
- Do not reveal whether an email exists during forgot-password requests.
- Audit login, logout, password change, evaluation submission, payments, and
  downloads.

## API Contract Conventions

### URLs and versions

- Base URL: `https://api.example.iuiu.ac.ug/api/v1`
- Use plural resource names.
- Put the major API version in the path.
- Use query parameters for filtering, sorting, and pagination.

### JSON

- Use `camelCase` JSON properties.
- Use ISO 8601 UTC timestamps, for example `2026-07-30T08:15:00Z`.
- Send stable IDs as strings.
- Send money as integer minor units or an explicit decimal plus currency.
- Never send formatted dates, currency strings, colors, or icons as source
  data. Flutter formats them for display.

### Success responses

Return the resource directly for single objects:

```json
{
  "id": "course-bit-3202",
  "courseCode": "BIT 3202",
  "courseTitle": "Business Intelligence and Data Warehousing"
}
```

Use a consistent page shape for collections:

```json
{
  "items": [],
  "page": 1,
  "pageSize": 20,
  "totalItems": 0,
  "totalPages": 0
}
```

### Errors

Use RFC Problem Details through `AddProblemDetails()`:

```json
{
  "type": "https://api.iuiu.ac.ug/problems/validation",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "detail": "Review the submitted fields.",
  "traceId": "00-...",
  "errors": {
    "semester": ["Semester is required."]
  }
}
```

Expected status codes:

| Status | Meaning |
|---|---|
| `200` | Successful read or update |
| `201` | Resource created |
| `204` | Successful operation with no body |
| `400` | Invalid input |
| `401` | Missing, invalid, or expired authentication |
| `403` | Authenticated but not permitted |
| `404` | Resource does not exist or must not be disclosed |
| `409` | Duplicate or conflicting state |
| `413` | Attachment exceeds the allowed size |
| `422` | Valid JSON that violates a business rule |
| `429` | Rate limit exceeded |
| `500` | Unexpected server error |

ASP.NET Core can generate Problem Details responses through its error-handling
services. See [ASP.NET Core error handling](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/error-handling?view=aspnetcore-10.0).

## Feature Endpoint Map

### Campuses and profile

```text
GET    /api/v1/campuses
GET    /api/v1/profile/me
PUT    /api/v1/profile/me
POST   /api/v1/profile/change-password
```

The profile response should contain stable user and campus IDs alongside the
fields already shown by `ProfileScreen`.

### Campus directory

```text
GET /api/v1/directory?campusId=kampala&type=student&query=aisha&page=1&pageSize=20
GET /api/v1/directory/{personId}
```

Only return contact fields the current user is authorized to view. Directory
permissions may differ for students, lecturers, and administrators.

### Messages and chat

```text
GET    /api/v1/messages/conversations
POST   /api/v1/messages/conversations
GET    /api/v1/messages/conversations/{conversationId}/messages
POST   /api/v1/messages/conversations/{conversationId}/messages
POST   /api/v1/messages/attachments
POST   /api/v1/messages/conversations/{conversationId}/read
DELETE /api/v1/messages/{messageId}
```

Use SignalR at `/hubs/chat` for new-message, typing, read-receipt, and presence
events. SignalR is intended for server-pushed real-time features such as chat
and notifications.

Store attachment metadata in SQL and the binary object in approved object
storage. Validate MIME type, extension, size, and file signature. Scan uploads
before making them downloadable. The API should return short-lived authorized
download URLs rather than exposing storage credentials.

Example message response:

```json
{
  "id": "message-01J...",
  "conversationId": "conversation-01J...",
  "senderId": "user-01J...",
  "text": "The campus today",
  "sentAt": "2026-07-30T08:20:00Z",
  "attachments": [
    {
      "id": "attachment-01J...",
      "fileName": "campus-photo.jpg",
      "contentType": "image/jpeg",
      "sizeBytes": 1887436,
      "downloadUrl": "https://..."
    }
  ]
}
```

### Registration and course units

```text
GET  /api/v1/registration/periods
GET  /api/v1/registration/records
GET  /api/v1/registration/records/{registrationId}
GET  /api/v1/registration/records/{registrationId}/course-units
POST /api/v1/registration/records/{registrationId}/course-units
POST /api/v1/registration/records/{registrationId}/submit
```

Registration writes require server-side checks for academic period, course
prerequisites, duplicate units, credit limits, retakes, and registration
deadlines.

### Lecturer evaluation

```text
GET  /api/v1/evaluations/periods
GET  /api/v1/evaluations?periodId={periodId}
GET  /api/v1/evaluations/{evaluationId}/questions
POST /api/v1/evaluations/{evaluationId}/submit
```

Evaluation confidentiality must be enforced by the backend. Do not expose the
student identity in lecturer-facing reports. Prevent duplicate submissions with
a database uniqueness constraint.

### Timetables

```text
GET /api/v1/timetables/options
GET /api/v1/timetables?type=class&studySystem=semester&academicYear=2025-2026&term=2
GET /api/v1/timetables?type=test&studySystem=quarter&academicYear=2026-2027&term=1
GET /api/v1/timetables?type=exam&studySystem=semester&academicYear=2026-2027&term=2
```

Use enums or validated values for `type` and `studySystem`. Return the selected
period and entries in one response:

```json
{
  "period": {
    "studySystem": "semester",
    "academicYear": "2025/2026",
    "term": 2,
    "termLabel": "Semester 2"
  },
  "entries": []
}
```

### Results and coursework

```text
GET /api/v1/results/periods
GET /api/v1/results?year=1&semester=1
GET /api/v1/results/coursework?year=1&semester=1
```

GPA, CGPA, grade, grade point, and classification must be calculated or
validated on the server. Flutter only displays the authoritative values.

### Fees and SchoolPay

```text
GET  /api/v1/fees/ledger?page=1&pageSize=20
POST /api/v1/fees/payment-sessions
GET  /api/v1/fees/payment-sessions/{sessionId}
POST /api/v1/integrations/schoolpay/webhook
```

Payment rules:

- Never trust an amount, balance, or payment status calculated by Flutter.
- Create payment sessions server-side.
- Verify SchoolPay webhook signatures.
- Make webhook processing idempotent.
- Store the provider reference and raw event audit metadata.
- Reconcile payment state asynchronously.
- Return the balance as a numeric amount and explicit `CR`/`DR` type.
- Never store card or mobile-money credentials in this API.

### Library

```text
GET  /api/v1/library/profile
GET  /api/v1/library/categories
GET  /api/v1/library/resources?categoryId=law-library&query=1959&page=1
POST /api/v1/library/resources/{resourceId}/download
POST /api/v1/library/ebook-requests
GET  /api/v1/library/catalog?query=clean+code&page=1
GET  /api/v1/library/catalog/{bookId}
```

The download endpoint should authorize access, record the audit event, and
return a short-lived URL or stream the content. Do not return a permanent public
storage URL for protected material.

## Database Starting Point

Suggested core tables:

```text
Users
Campuses
UserCampuses
StudentProfiles
StaffProfiles
AcademicPeriods
Programmes
Courses
CourseOfferings
Registrations
RegistrationCourseUnits
EvaluationPeriods
EvaluationQuestions
EvaluationSubmissions
EvaluationAnswers
TimetableEntries
ResultPeriods
CourseResults
CourseworkResults
FeeLedgerEntries
PaymentSessions
PaymentWebhookEvents
Conversations
ConversationMembers
Messages
MessageAttachments
LibraryMembers
LibraryCategories
LibraryResources
CatalogBooks
BorrowedBooks
EbookRequests
AuditEvents
RefreshTokens
```

Database requirements:

- Use internal stable primary keys.
- Add unique constraints for business identifiers.
- Add indexes for directory search, conversation ordering, timetable periods,
  ledger ordering, and catalog search.
- Add optimistic concurrency tokens where records may be edited concurrently.
- Use EF Core migrations and review migration SQL before production.
- Keep payment and evaluation audit data append-only where practical.

## Example Feature Endpoint

```csharp
public static class ResultEndpoints
{
    public static RouteGroupBuilder MapResultEndpoints(
        this RouteGroupBuilder group)
    {
        group.MapGet("/", GetResults)
            .WithName("GetResults")
            .Produces<ResultPeriodResponse>()
            .ProducesProblem(StatusCodes.Status400BadRequest)
            .Produces(StatusCodes.Status401Unauthorized);

        return group;
    }

    private static async Task<IResult> GetResults(
        int year,
        int semester,
        ClaimsPrincipal user,
        IResultService service,
        CancellationToken cancellationToken)
    {
        var userId = user.FindFirstValue("sub");
        var result = await service.GetResultsAsync(
            userId!,
            year,
            semester,
            cancellationToken);

        return result is null ? Results.NotFound() : Results.Ok(result);
    }
}
```

The endpoint should delegate business logic to a feature service. It should not
return EF Core entities directly.

## Flutter Integration Structure

When API integration begins, each feature should gain only the abstractions it
actually needs:

```text
lib/features/results/
  data/
    results_api_data_source.dart
    results_dto.dart
    results_repository_impl.dart
    results_mock_data.dart
  models/
    academic_result.dart
  presentation/
    results_screen.dart
  results_repository.dart
```

Example repository boundary:

```dart
abstract interface class ResultsRepository {
  Future<List<AcademicResultPeriod>> getPeriods();

  Future<AcademicResultPeriod> getResults({
    required int year,
    required int semester,
  });
}
```

Example DTO mapping:

```dart
class CourseResultDto {
  const CourseResultDto({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.creditUnits,
    required this.score,
    required this.grade,
    required this.gradePoint,
  });

  factory CourseResultDto.fromJson(Map<String, dynamic> json) {
    return CourseResultDto(
      id: json['id'] as String,
      courseCode: json['courseCode'] as String,
      courseTitle: json['courseTitle'] as String,
      creditUnits: json['creditUnits'] as int,
      score: json['score'] as int,
      grade: json['grade'] as String,
      gradePoint: (json['gradePoint'] as num).toDouble(),
    );
  }

  CourseResult toModel() {
    return CourseResult(
      id: id,
      courseCode: courseCode,
      courseTitle: courseTitle,
      creditUnits: creditUnits,
      score: score,
      grade: grade,
      gradePoint: gradePoint,
    );
  }
}
```

Rules for Flutter:

- Keep API DTOs in `data/`.
- Map DTOs into the existing immutable presentation models.
- Inject repositories or loaded models into screens.
- Keep formatting in Flutter.
- Keep navigation callbacks out of DTOs and models.
- Preserve mock repositories for widget tests and offline UI development.
- Add an HTTP package only when API integration is authorized.
- Add secure token storage only after selecting and reviewing a suitable
  platform-secure package.
- Never store access or refresh tokens in plain preferences.

## Migrating One Feature Safely

Use Results as the first read-only pilot:

1. Freeze the existing Results widget and golden/widget expectations.
2. Approve the OpenAPI contract.
3. Implement the ASP.NET Results endpoints.
4. Add backend unit and integration tests.
5. Add Flutter DTOs and repository interface.
6. Map API DTOs to the existing `AcademicResultPeriod`, `CourseResult`, and
   `CourseworkResult` models.
7. Inject the repository into the screen or a small presentation controller.
8. Show loading and retry states without changing the successful-data layout.
9. Run Flutter widget tests using a fake repository.
10. Compare API-backed rendering with the current mock-backed rendering.
11. Enable the API repository through environment configuration.
12. Keep a rollback path to the mock/fake source until the endpoint is stable.

Use this overall delivery order:

1. Establish the platform foundation: database, OpenAPI, Problem Details,
   authentication, authorization, health checks, and deployment environments.
2. Pilot a read-only Flutter integration with Results, followed by Timetables.
3. Integrate Campuses, Profile, and Directory.
4. Integrate Registration reads and Lecturer Evaluation submission.
5. Integrate Fees ledger reads and Library resources.
6. Add real-time Messaging and media attachments.
7. Add SchoolPay transaction creation and webhook processing last.

Authentication must exist before protected endpoints are exposed to the mobile
application. Results remains the recommended first screen integration because
it proves the API contract and Flutter mapping without introducing payment,
upload, or write-operation risk.

## Configuration and Environments

ASP.NET configuration:

```json
{
  "ConnectionStrings": {
    "IuiuDatabase": ""
  },
  "Authentication": {
    "Authority": "",
    "Audience": "iuiu-mobile-api"
  },
  "Storage": {
    "Provider": "",
    "Bucket": ""
  },
  "SchoolPay": {
    "BaseUrl": "",
    "MerchantId": ""
  }
}
```

Do not commit production secrets. Supply them through environment variables,
deployment secret stores, or managed identities.

Recommended environments:

```text
Local       Local developer database and fake external services
Test        Automated integration tests
Staging     Production-like data shape with test users/payments
Production  Restricted production credentials and monitoring
```

Flutter should receive its API base URL through build-time environment
configuration, not a hardcoded production URL.

## Reliability and Operations

- Add `/healthz` for liveness and a protected readiness check for database and
  required dependencies. ASP.NET Core includes health-check middleware.
- Add structured logs with request/trace IDs.
- Never log passwords, tokens, message contents, payment secrets, or sensitive
  profile values.
- Add OpenTelemetry traces and metrics if supported by IUIU infrastructure.
- Rate-limit login, forgot password, directory search, catalog search, file
  download, and messaging endpoints. ASP.NET Core provides first-party rate
  limiting middleware.
- Use cancellation tokens for database and external service calls.
- Apply database migrations through a controlled deployment step.
- Back up the database and test restoration.
- Define retention policies for chat media, audit data, and password-reset
  tokens.

References:

- [ASP.NET Core rate limiting](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit?view=aspnetcore-10.0)
- [ASP.NET Core health checks](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-10.0)
- [ASP.NET Core hosting and deployment](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/?view=aspnetcore-10.0)

## Testing Strategy

### Backend

- Unit-test grade calculations, registration rules, fee balance rules,
  evaluation constraints, and authorization decisions.
- Integration-test endpoints with `WebApplicationFactory`.
- Run tests against the actual selected database engine in containers or an
  isolated test database.
- Contract-test JSON and OpenAPI compatibility.
- Test `401`, `403`, validation, pagination, concurrency, and idempotency.
- Load-test directory, messages, library resources, and fee ledger endpoints.
- Security-test upload validation and object-level authorization.

### Flutter

- Unit-test DTO parsing and DTO-to-model mapping.
- Repository-test success, Problem Details, timeouts, and malformed payloads.
- Widget-test loading, success, empty, retry, and authorization-expired states.
- Continue testing phone, tablet, and text-scaled layouts.
- Keep successful API-backed UI identical to the mock-backed UI.

## Definition of Done for an Endpoint

An endpoint is complete only when:

- Its request and response are documented in OpenAPI.
- Authentication and object-level authorization are enforced.
- Input validation and Problem Details errors are implemented.
- EF queries are cancellable and avoid unnecessary data loading.
- Unit and integration tests pass.
- Audit logging is added where required.
- Sensitive data is absent from logs.
- The Flutter DTO maps into an existing presentation model.
- Loading, empty, retry, and expired-session behavior are tested.
- The approved UI remains unchanged for successful data.

## Decisions Required Before Coding the Backend

The team must confirm:

1. SQL Server or PostgreSQL.
2. Existing university identity provider, if any.
3. Whether students and staff share one identity directory.
4. SchoolPay API and webhook specifications.
5. Approved storage for chat and library files.
6. Data ownership: ERP database, learning system, library system, or the new
   API database.
7. Whether the API reads existing databases directly or synchronizes data.
8. Roles and permissions for student, lecturer, librarian, finance, and
   administrator users.
9. Data-retention and privacy requirements.
10. Hosting target: IIS, Linux service, containers, or cloud platform.

These decisions affect infrastructure and security but should not require a
redesign of the Flutter screens.
