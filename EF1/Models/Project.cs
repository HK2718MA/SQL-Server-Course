using System;
using System.Collections.Generic;

namespace CompanyEFCore.Models;

public partial class Project
{
    public int ProjId { get; set; }

    public string ProjName { get; set; } = null!;

    public int? DeptId { get; set; }

    public virtual Department? Dept { get; set; }

    public virtual ICollection<Employee> Emps { get; set; } = new List<Employee>();
}
