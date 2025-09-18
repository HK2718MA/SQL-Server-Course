using System;
using System.Collections.Generic;

namespace CompanyEFCore.Models;

public partial class Dependent
{
    public int DepId { get; set; }

    public string DepName { get; set; } = null!;

    public string? Relationship { get; set; }

    public int? EmpId { get; set; }

    public virtual Employee? Emp { get; set; }
}
