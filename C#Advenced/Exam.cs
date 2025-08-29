using ExaminationSystem;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem
{
    public class Exam
    {
        public string Title { get; set; } = string.Empty;
        public Course Course { get; set; }
        public List<Question> Questions { get; set; } = new List<Question>();
        public bool IsStarted { get; private set; } = false;

        public Exam(string title, Course course)
        {
            Title = title;
            Course = course;
        }

        public void StartExam()
        {
            IsStarted = true;
        }

        public void AddQuestion(Question question, int marks)
        {
            if (IsStarted)
            {
                Console.WriteLine("لا يمكن تعديل الامتحان بعد بدايته");
                return;
            }

            int totalMarks = Questions.Sum(q => q.Marks) + marks;
            if (totalMarks > Course.MaxDegree)
            {
                Console.WriteLine("مجموع الدرجات تجاوز الحد الأقصى للكورس");
                return;
            }

            question.Marks = marks;
            Questions.Add(question);
        }
    }
}
