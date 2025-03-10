using Microsoft.EntityFrameworkCore;

namespace DartDbLib;

public class DartContext : DbContext
{
    public DbSet<Player> Players { get; set; }
    public DbSet<Game> Games { get; set; }
    public DbSet<GameResult> GameResults { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlite("Data Source=/home/niklas/tmp/DartDB.sqlite;");
    }
}