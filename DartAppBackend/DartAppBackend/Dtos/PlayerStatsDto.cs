namespace DartAppBackend.Dtos;


public class PlayerStatsDto
{
    public int PlayerId { get; set; }
    public string Name { get; set; }
    public int TotalGames { get; set; }
    public int Wins { get; set; }
    public double WinRatio { get; set; }
}
