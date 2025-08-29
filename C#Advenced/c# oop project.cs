using System;
using System.Collections.Generic;
using System.Linq;

namespace ExaminationSystem
{
    class Program
    {
        static List<Course> Courses = new List<Course>();
        static List<Student> Students = new List<Student>();
        static List<Instructor> Instructors = new List<Instructor>();
        static List<ExamResult> Results = new List<ExamResult>();

        static void Main(string[] args)
        {
            while (true)
            {
                Console.WriteLine("\n===== Examination System =====");
                Console.WriteLine("1. Add Course");
                Console.WriteLine("2. Add Student");
                Console.WriteLine("3. Add Instructor");
                Console.WriteLine("4. Create Exam");
                Console.WriteLine("5. Student Takes Exam");
                Console.WriteLine("6. Show Reports");
                Console.WriteLine("7. Compare Two Students");
                Console.WriteLine("0. Exit");
                Console.Write("Choose: ");
                string choice = Console.ReadLine() ?? "";

                switch (choice)
                {
                    case "1": AddCourse(); break;
                    case "2": AddStudent(); break;
                    case "3": AddInstructor(); break;
                    case "4": CreateExam(); break;
                    case "5": TakeExam(); break;
                    case "6": ShowReports(); break;
                    case "7": CompareStudents(); break;
                    case "0": return;
                    default: Console.WriteLine("Invalid Choice"); break;
                }
            }
        }

        static void AddCourse()
        {
            Console.Write("Course Title: ");
            string title = Console.ReadLine() ?? "";

            Console.Write("Description: ");
            string desc = Console.ReadLine() ?? "";

            Console.Write("Max Degree: ");
            int maxDegree = int.Parse(Console.ReadLine() ?? "100");

            Courses.Add(new Course(title, desc, maxDegree));
            Console.WriteLine(" Course Added!");
        }

        static void AddStudent()
        {
            Console.Write("Student ID: ");
            int id = int.Parse(Console.ReadLine() ?? "0");

            Console.Write("Name: ");
            string name = Console.ReadLine() ?? "";

            Console.Write("Email: ");
            string email = Console.ReadLine() ?? "";

            Students.Add(new Student(id, name, email));
            Console.WriteLine(" Student Added!");
        }

        static void AddInstructor()
        {
            Console.Write("Instructor ID: ");
            int id = int.Parse(Console.ReadLine() ?? "0");

            Console.Write("Name: ");
            string name = Console.ReadLine() ?? "";

            Console.Write("Specialization: ");
            string spec = Console.ReadLine() ?? "";

            Instructors.Add(new Instructor(id, name, spec));
            Console.WriteLine(" Instructor Added!");
        }

        static void CreateExam()
        {
            if (Courses.Count == 0) { Console.WriteLine("No Courses!"); return; }

            Console.WriteLine("Select Course:");
            for (int i = 0; i < Courses.Count; i++)
                Console.WriteLine($"{i + 1}. {Courses[i].Title}");

            int cIndex = int.Parse(Console.ReadLine() ?? "1") - 1;
            var course = Courses[cIndex];

            Console.Write("Exam Title: ");
            string title = Console.ReadLine() ?? "";

            Exam exam = new Exam(title, course);

            Console.Write("How many questions? ");
            int qCount = int.Parse(Console.ReadLine() ?? "1");

            for (int i = 0; i < qCount; i++)
            {
                Console.WriteLine($"--- Question {i + 1} ---");
                Console.WriteLine("1. MCQ");
                Console.WriteLine("2. True/False");
                Console.WriteLine("3. Essay");
                Console.Write("Choose Type: ");
                string type = Console.ReadLine() ?? "";

                Console.Write("Question Text: ");
                string qText = Console.ReadLine() ?? "";

                Console.Write("Marks: ");
                int marks = int.Parse(Console.ReadLine() ?? "1");

                Question q;
                if (type == "1")
                {
                    var mcq = new MCQQuestion { Text = qText };
                    Console.Write("Enter Correct Answer: ");
                    mcq.CorrectAnswer = Console.ReadLine() ?? "";
                    mcq.Options.Add("Option A");
                    mcq.Options.Add("Option B");
                    mcq.Options.Add("Option C");
                    q = mcq;
                }
                else if (type == "2")
                {
                    var tf = new TrueFalseQuestion { Text = qText };
                    Console.Write("Correct Answer (true/false): ");
                    tf.CorrectAnswer = bool.Parse(Console.ReadLine() ?? "true");
                    q = tf;
                }
                else
                {
                    q = new EssayQuestion { Text = qText };
                }

                exam.AddQuestion(q, marks);
            }

            course.Instructors.FirstOrDefault()?.CreateExam(course, title); 
            course.Instructors.FirstOrDefault()?.DuplicateExam(exam, course);

            Console.WriteLine("Exam Created!");
        }

        static void TakeExam()
        {
            if (Students.Count == 0 || Courses.Count == 0) { Console.WriteLine("Add Students/Courses first!"); return; }

            Console.WriteLine("Select Student:");
            for (int i = 0; i < Students.Count; i++)
                Console.WriteLine($"{i + 1}. {Students[i].Name}");

            int sIndex = int.Parse(Console.ReadLine() ?? "1") - 1;
            var student = Students[sIndex];

            Console.WriteLine("Select Course:");
            for (int i = 0; i < Courses.Count; i++)
                Console.WriteLine($"{i + 1}. {Courses[i].Title}");

            int cIndex = int.Parse(Console.ReadLine() ?? "1") - 1;
            var course = Courses[cIndex];

            var exam = new Exam($"{course.Title} Final", course);
            exam.StartExam();

            int score = 0;
            foreach (var q in exam.Questions)
            {
                Console.WriteLine(q.Text);
                Console.Write("Answer: ");
                string ans = Console.ReadLine() ?? "";

                if (q.CheckAnswer(ans))
                    score += q.Marks;
            }

            Results.Add(new ExamResult(exam, student, score));
            Console.WriteLine($"Exam Finished! Score = {score}/{course.MaxDegree}");
        }

        static void ShowReports()
        {
            foreach (var r in Results)
            {
                Console.WriteLine($"{r.Student.Name} | {r.Exam.Title} | {r.Exam.Course.Title} | Score: {r.Score} | {(r.Score >= (r.Exam.Course.MaxDegree / 2) ? "Pass" : "Fail")}");
            }
        }

        static void CompareStudents()
        {
            Console.Write("Enter Student1 Name: ");
            var s1 = Students.FirstOrDefault(s => s.Name == Console.ReadLine());

            Console.Write("Enter Student2 Name: ");
            var s2 = Students.FirstOrDefault(s => s.Name == Console.ReadLine());

            if (s1 == null || s2 == null) { Console.WriteLine("Student not found!"); return; }

            var r1 = Results.FirstOrDefault(r => r.Student == s1);
            var r2 = Results.FirstOrDefault(r => r.Student == s2);

            if (r1 == null || r2 == null) { Console.WriteLine("Results not found!"); return; }

            Console.WriteLine($"{s1.Name}: {r1.Score} vs {s2.Name}: {r2.Score}");
            Console.WriteLine(r1.Score > r2.Score ? $"{s1.Name} Wins!" : $"{s2.Name} Wins!");
        }
    }
}

