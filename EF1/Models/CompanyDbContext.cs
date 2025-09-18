using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace CompanyEFCore.Models;

public partial class CompanyDbContext : DbContext
{
    public CompanyDbContext()
    {
    }

    public CompanyDbContext(DbContextOptions<CompanyDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Dependent> Dependents { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<Project> Projects { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=HabibaKHALED\\SQLEXPRESS;Database=CompanyDB;Trusted_Connection=True;Encrypt=False;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.DeptId).HasName("PK__Departme__0148818E3D493D11");

            entity.ToTable("Departments", "hr");

            entity.HasIndex(e => e.DeptName, "UQ__Departme__5E5082652BD5280B").IsUnique();

            entity.Property(e => e.DeptId)
                .ValueGeneratedNever()
                .HasColumnName("DeptID");
            entity.Property(e => e.DeptName).HasMaxLength(100);
            entity.Property(e => e.Location).HasMaxLength(100);
            entity.Property(e => e.ManagerId).HasColumnName("ManagerID");
        });

        modelBuilder.Entity<Dependent>(entity =>
        {
            entity.HasKey(e => e.DepId).HasName("PK__Dependen__DB9CAA7FAD212FCC");

            entity.ToTable("Dependents", "hr");

            entity.Property(e => e.DepId).HasColumnName("DepID");
            entity.Property(e => e.DepName).HasMaxLength(100);
            entity.Property(e => e.EmpId).HasColumnName("EmpID");
            entity.Property(e => e.Relationship).HasMaxLength(50);

            entity.HasOne(d => d.Emp).WithMany(p => p.Dependents)
                .HasForeignKey(d => d.EmpId)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK__Dependent__EmpID__4AB81AF0");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.EmpId).HasName("PK__Employee__AF2DBA7975E15052");

            entity.ToTable("Employees", "hr");

            entity.HasIndex(e => e.Email, "UQ__Employee__A9D105347C1EF1CE").IsUnique();

            entity.HasIndex(e => e.Ssn, "UQ__Employee__CA1E8E3CD6C04F81").IsUnique();

            entity.Property(e => e.EmpId).HasColumnName("EmpID");
            entity.Property(e => e.DeptId).HasColumnName("DeptID");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Fname)
                .HasMaxLength(100)
                .HasColumnName("FName");
            entity.Property(e => e.Gender)
                .HasMaxLength(1)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.HireDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Lname)
                .HasMaxLength(50)
                .HasColumnName("LName");
            entity.Property(e => e.Nationality).HasMaxLength(50);
            entity.Property(e => e.Ssn)
                .HasMaxLength(14)
                .IsUnicode(false)
                .IsFixedLength()
                .HasColumnName("SSN");

            entity.HasOne(d => d.Dept).WithMany(p => p.Employees)
                .HasForeignKey(d => d.DeptId)
                .HasConstraintName("FK__Employees__DeptI__3E52440B");

            entity.HasMany(d => d.Projs).WithMany(p => p.Emps)
                .UsingEntity<Dictionary<string, object>>(
                    "EmployeeProject",
                    r => r.HasOne<Project>().WithMany()
                        .HasForeignKey("ProjId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__EmployeeP__ProjI__47DBAE45"),
                    l => l.HasOne<Employee>().WithMany()
                        .HasForeignKey("EmpId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("FK__EmployeeP__EmpID__46E78A0C"),
                    j =>
                    {
                        j.HasKey("EmpId", "ProjId").HasName("PK__Employee__7E4FA8D643A222A1");
                        j.ToTable("EmployeeProjects", "hr");
                        j.IndexerProperty<int>("EmpId").HasColumnName("EmpID");
                        j.IndexerProperty<int>("ProjId").HasColumnName("ProjID");
                    });
        });

        modelBuilder.Entity<Project>(entity =>
        {
            entity.HasKey(e => e.ProjId).HasName("PK__Projects__16212AFC5FF56C0F");

            entity.ToTable("Projects", "hr");

            entity.Property(e => e.ProjId)
                .ValueGeneratedNever()
                .HasColumnName("ProjID");
            entity.Property(e => e.DeptId).HasColumnName("DeptID");
            entity.Property(e => e.ProjName).HasMaxLength(100);

            entity.HasOne(d => d.Dept).WithMany(p => p.Projects)
                .HasForeignKey(d => d.DeptId)
                .HasConstraintName("FK__Projects__DeptID__440B1D61");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
