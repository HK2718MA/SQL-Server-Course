using AssignmentDemo;
using System.Collections.Generic;
using System;

class Program
{
    static async Task Main()
    {
        
        var pb = new PhoneBook(); pb["Ali"] = "123"; Console.WriteLine(pb["Ali"]);

        
        var ws = new WeeklySchedule(); ws["Monday"] = "Work"; Console.WriteLine(ws["Monday"]);

        
        var m = new Matrix(2, 2); m[0, 1] = 10; Console.WriteLine(m[0, 1]);

        
        var st = new MyStack<int>(); st.Push(5); Console.WriteLine(st.Pop());

        
        var pr = new Pair<string, int>("Age", 30); Console.WriteLine($"{pr.First}:{pr.Second}");

        
        var cache = new Cache<string, string>(); cache.Add("k", "v", 5); Console.WriteLine(cache.Get("k"));

        
        var nums = new List<int> { 1, 2, 3 };
        var strs = ConverterUtil.ConvertList(nums, n => n.ToString());
        Console.WriteLine(string.Join(",", strs));

        
        var cm = new ContactManager(); cm.Add("Ali", "555"); Console.WriteLine(cm.Search("Ali"));

        
        var cart = new Cart(); cart.Items.Add("Apple"); cart.Qty["Apple"] = 2; Console.WriteLine(cart.Qty["Apple"]);

        
        Console.WriteLine(MathUtils.Average(new List<int?> { 1, null, 3 }));

        
        Console.WriteLine(5.IsEven()); Console.WriteLine(5.Factorial());

        
        Console.WriteLine(DateTime.Now.StartOfWeek());

        
        foreach (var batch in nums.Batch(2)) Console.WriteLine(string.Join("-", batch));

        
        Operation op = (a, b) => a + b; Console.WriteLine(op(2, 3));

        
        var n = new Notifier(); n.Notify += msg => Console.WriteLine($"Notify: {msg}"); n.Send("Hello");

        
        var pm = new PluginManager(); pm.Register(() => Console.WriteLine("Rule executed")); pm.Execute();

        
        var pipe = new Pipeline { Process = x => x * 2 }; Console.WriteLine(pipe.Run(5));

       
        var grades = new List<int> { 50, 80, 90 };
        var passed = grades.Where(g => g >= 60);
        Console.WriteLine(string.Join(",", passed));

        
        var v = new Validator<int>(); v.AddRule(x => x > 0); Console.WriteLine(v.Validate(5));

        
        var t = new MyTimer(); t.Tick += () => Console.WriteLine("Tick"); t.Done += () => Console.WriteLine("Done");
        t.Start(2);

        
        var fs = new FileService(); await fs.Write("test.txt", "Hello"); Console.WriteLine(await fs.Read("test.txt"));

        
        var api = new ApiService(); Console.WriteLine(await api.GetAll());

        
        var qs = new QueueService<string>();
        qs.Enqueue("Task1");
        await qs.Process();

        
        var c = new Counter(); c.Inc(); Console.WriteLine(c.Get());

        
        var email = new EmailSender(); await email.Send("test@mail.com");

        
        var tr = new Transaction(); tr.Run(() => throw new Exception("fail"));

        try { throw new InvalidEmailException("Bad Email"); }
        catch (InvalidEmailException ex) { Console.WriteLine(ex.Message); }
    }
}
