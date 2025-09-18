using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace ExamSys.Models.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Courses",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    MaximumDegree = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Courses", x => x.Id);
                    table.CheckConstraint("CK_Course_MaximumDegree_Positive", "[MaximumDegree] > 0");
                });

            migrationBuilder.CreateTable(
                name: "Instructors",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Specialization = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    HireDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Instructors", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Students",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    StudentNumber = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    EnrollmentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Students", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Exams",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Title = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    TotalMarks = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Duration = table.Column<TimeSpan>(type: "time", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true),
                    CourseId = table.Column<int>(type: "int", nullable: false),
                    InstructorId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Exams", x => x.Id);
                    table.CheckConstraint("CK_Exam_EndAfterStart", "[EndDate] > [StartDate]");
                    table.ForeignKey(
                        name: "FK_Exams_Courses_CourseId",
                        column: x => x.CourseId,
                        principalTable: "Courses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Exams_Instructors_InstructorId",
                        column: x => x.InstructorId,
                        principalTable: "Instructors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "InstructorCourses",
                columns: table => new
                {
                    InstructorId = table.Column<int>(type: "int", nullable: false),
                    CourseId = table.Column<int>(type: "int", nullable: false),
                    AssignedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InstructorCourses", x => new { x.InstructorId, x.CourseId });
                    table.ForeignKey(
                        name: "FK_InstructorCourses_Courses_CourseId",
                        column: x => x.CourseId,
                        principalTable: "Courses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InstructorCourses_Instructors_InstructorId",
                        column: x => x.InstructorId,
                        principalTable: "Instructors",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StudentCourses",
                columns: table => new
                {
                    StudentId = table.Column<int>(type: "int", nullable: false),
                    CourseId = table.Column<int>(type: "int", nullable: false),
                    EnrollmentDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Grade = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    IsCompleted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentCourses", x => new { x.StudentId, x.CourseId });
                    table.ForeignKey(
                        name: "FK_StudentCourses_Courses_CourseId",
                        column: x => x.CourseId,
                        principalTable: "Courses",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_StudentCourses_Students_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Students",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ExamAttempts",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    StartTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndTime = table.Column<DateTime>(type: "datetime2", nullable: true),
                    TotalScore = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    IsSubmitted = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    IsGraded = table.Column<bool>(type: "bit", nullable: false, defaultValue: false),
                    StudentId = table.Column<int>(type: "int", nullable: false),
                    ExamId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExamAttempts", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExamAttempts_Exams_ExamId",
                        column: x => x.ExamId,
                        principalTable: "Exams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExamAttempts_Students_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Students",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Questions",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    QuestionText = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: false),
                    Marks = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    QuestionType = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExamId = table.Column<int>(type: "int", nullable: false),
                    QuestionDiscriminator = table.Column<int>(type: "int", nullable: false),
                    MaxWordCount = table.Column<int>(type: "int", nullable: true),
                    GradingCriteria = table.Column<string>(type: "nvarchar(1000)", maxLength: 1000, nullable: true),
                    OptionA = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    OptionB = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    OptionC = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    OptionD = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    CorrectOption = table.Column<string>(type: "nvarchar(1)", nullable: true),
                    CorrectAnswer = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Questions", x => x.Id);
                    table.CheckConstraint("CK_Question_Marks_Positive", "[Marks] > 0");
                    table.ForeignKey(
                        name: "FK_Questions_Exams_ExamId",
                        column: x => x.ExamId,
                        principalTable: "Exams",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "StudentAnswers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    AnswerText = table.Column<string>(type: "nvarchar(2000)", maxLength: 2000, nullable: false),
                    SelectedOption = table.Column<string>(type: "nvarchar(1)", nullable: true),
                    BooleanAnswer = table.Column<bool>(type: "bit", nullable: true),
                    MarksObtained = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ExamAttemptId = table.Column<int>(type: "int", nullable: false),
                    QuestionId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StudentAnswers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_StudentAnswers_ExamAttempts_ExamAttemptId",
                        column: x => x.ExamAttemptId,
                        principalTable: "ExamAttempts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_StudentAnswers_Questions_QuestionId",
                        column: x => x.QuestionId,
                        principalTable: "Questions",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "Courses",
                columns: new[] { "Id", "CreatedDate", "Description", "IsActive", "MaximumDegree", "Title" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 9, 18, 18, 47, 25, 623, DateTimeKind.Utc).AddTicks(3753), "SE Course", true, 100m, "Software Engineering" },
                    { 2, new DateTime(2025, 9, 18, 18, 47, 25, 623, DateTimeKind.Utc).AddTicks(4463), "DB Course", true, 100m, "Databases" },
                    { 3, new DateTime(2025, 9, 18, 18, 47, 25, 623, DateTimeKind.Utc).AddTicks(4466), "Intro", true, 100m, "Programming Fundamentals" }
                });

            migrationBuilder.InsertData(
                table: "Instructors",
                columns: new[] { "Id", "Email", "HireDate", "IsActive", "Name", "Specialization" },
                values: new object[,]
                {
                    { 1, "smith@example.com", new DateTime(2020, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(8920), true, "Dr. Smith", "Software Engineering" },
                    { 2, "jones@example.com", new DateTime(2022, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(9766), true, "Dr. Jones", "Databases" }
                });

            migrationBuilder.InsertData(
                table: "Students",
                columns: new[] { "Id", "Email", "EnrollmentDate", "IsActive", "Name", "StudentNumber" },
                values: new object[,]
                {
                    { 1, "alice@example.com", new DateTime(2025, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(5177), true, "Alice", "S1001" },
                    { 2, "bob@example.com", new DateTime(2025, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(5875), true, "Bob", "S1002" },
                    { 3, "charlie@example.com", new DateTime(2025, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(5920), true, "Charlie", "S1003" },
                    { 4, "diana@example.com", new DateTime(2025, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(5923), true, "Diana", "S1004" },
                    { 5, "eve@example.com", new DateTime(2025, 9, 18, 18, 47, 25, 624, DateTimeKind.Utc).AddTicks(5925), true, "Eve", "S1005" }
                });

            migrationBuilder.InsertData(
                table: "Exams",
                columns: new[] { "Id", "CourseId", "Description", "Duration", "EndDate", "InstructorId", "IsActive", "StartDate", "Title", "TotalMarks" },
                values: new object[,]
                {
                    { 1, 1, "Midterm SE", new TimeSpan(0, 2, 0, 0, 0), new DateTime(2025, 9, 25, 20, 47, 25, 625, DateTimeKind.Utc).AddTicks(3670), 1, true, new DateTime(2025, 9, 25, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(3306), "Midterm SE", 100m },
                    { 2, 2, "Final DB", new TimeSpan(0, 3, 0, 0, 0), new DateTime(2025, 9, 28, 21, 47, 25, 625, DateTimeKind.Utc).AddTicks(4897), 2, true, new DateTime(2025, 9, 28, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(4894), "Final DB", 100m }
                });

            migrationBuilder.InsertData(
                table: "InstructorCourses",
                columns: new[] { "CourseId", "InstructorId", "AssignedDate", "IsActive" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 9, 18, 18, 47, 25, 626, DateTimeKind.Utc).AddTicks(109), true },
                    { 2, 2, new DateTime(2025, 9, 18, 18, 47, 25, 626, DateTimeKind.Utc).AddTicks(792), true }
                });

            migrationBuilder.InsertData(
                table: "StudentCourses",
                columns: new[] { "CourseId", "StudentId", "EnrollmentDate", "Grade" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(9160), null },
                    { 1, 2, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(9982), null },
                    { 2, 3, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(9984), null }
                });

            migrationBuilder.InsertData(
                table: "Questions",
                columns: new[] { "Id", "CreatedDate", "ExamId", "Marks", "QuestionDiscriminator", "QuestionText", "QuestionType" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(5193), 1, 10m, null, "What is OOP?", 0 },
                    { 2, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(6496), 1, 5m, 1, "SQL is a programming language?", 1 },
                    { 3, new DateTime(2025, 9, 18, 18, 47, 25, 625, DateTimeKind.Utc).AddTicks(7424), 2, 20m, 2, "Discuss normalization.", 2 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_ExamAttempts_ExamId",
                table: "ExamAttempts",
                column: "ExamId");

            migrationBuilder.CreateIndex(
                name: "IX_ExamAttempts_StartTime",
                table: "ExamAttempts",
                column: "StartTime");

            migrationBuilder.CreateIndex(
                name: "IX_ExamAttempts_StudentId",
                table: "ExamAttempts",
                column: "StudentId");

            migrationBuilder.CreateIndex(
                name: "IX_Exams_CourseId",
                table: "Exams",
                column: "CourseId");

            migrationBuilder.CreateIndex(
                name: "IX_Exams_InstructorId",
                table: "Exams",
                column: "InstructorId");

            migrationBuilder.CreateIndex(
                name: "IX_Exams_StartDate",
                table: "Exams",
                column: "StartDate");

            migrationBuilder.CreateIndex(
                name: "IX_InstructorCourses_CourseId",
                table: "InstructorCourses",
                column: "CourseId");

            migrationBuilder.CreateIndex(
                name: "IX_Instructors_Email",
                table: "Instructors",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Questions_ExamId",
                table: "Questions",
                column: "ExamId");

            migrationBuilder.CreateIndex(
                name: "IX_StudentAnswers_ExamAttemptId",
                table: "StudentAnswers",
                column: "ExamAttemptId");

            migrationBuilder.CreateIndex(
                name: "IX_StudentAnswers_QuestionId",
                table: "StudentAnswers",
                column: "QuestionId");

            migrationBuilder.CreateIndex(
                name: "IX_StudentCourses_CourseId",
                table: "StudentCourses",
                column: "CourseId");

            migrationBuilder.CreateIndex(
                name: "IX_Students_Email",
                table: "Students",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Students_StudentNumber",
                table: "Students",
                column: "StudentNumber",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "InstructorCourses");

            migrationBuilder.DropTable(
                name: "StudentAnswers");

            migrationBuilder.DropTable(
                name: "StudentCourses");

            migrationBuilder.DropTable(
                name: "ExamAttempts");

            migrationBuilder.DropTable(
                name: "Questions");

            migrationBuilder.DropTable(
                name: "Students");

            migrationBuilder.DropTable(
                name: "Exams");

            migrationBuilder.DropTable(
                name: "Courses");

            migrationBuilder.DropTable(
                name: "Instructors");
        }
    }
}
