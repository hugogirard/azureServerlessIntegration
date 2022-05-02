using Microsoft.EntityFrameworkCore;

namespace LegacyApiOrder.Model;

public class OrderContext : DbContext
{

    public DbSet<Order> Orders { get; set; }

    public string DbPath { get; }

    public OrderContext()
    {
        var folder = Environment.SpecialFolder.LocalApplicationData;
        var path = Environment.GetFolderPath(folder);
        DbPath = $"{path}order.db";
    }

    // The following configures EF to create a Sqlite database file in the
    // special "local" folder for your platform.
    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite($"Data Source={DbPath}");
    
}