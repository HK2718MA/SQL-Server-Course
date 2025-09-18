using System;
using System.Collections.Generic;

namespace CompanyEFCore.Models;

public partial class Employee
{
    public int EmpId { get; set; }

    public string? Fname { get; set; }

    public string Lname { get; set; } = null!;

    public string Ssn { get; set; } = null!;

    public string? Gender { get; set; }

    public DateOnly? BirthDate { get; set; }

    public DateTime? HireDate { get; set; }

    public string? Email { get; set; }

    public int? DeptId { get; set; }

    public string? Nationality { get; set; }

    public virtual ICollection<Dependent> Dependents { get; set; } = new List<Dependent>();

    public virtual Department? Dept { get; set; }

    public virtual ICollection<Project> Projs { get; set; } = new List<Project>();
}
