using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Course
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public int MaxDegree { get; set; }

        public List<Student> EnrolledStudents { get; set; } = new List<Student>();
        public List<Instructor> Instructors { get; set; } = new List<Instructor>();

        public Course(string title, string description, int maxDegree)
        {
            Title = title;
            Description = description;
            MaxDegree = maxDegree;
        }
        public List<Exam> Exams { get; set; } = new List<Exam>();

        
        public void AddExam(Exam exam)
        {
            Exams.Add(exam);
        }
    }
}
