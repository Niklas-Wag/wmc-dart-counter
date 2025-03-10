namespace DartDbLib;

public class Game
{
    public int Id { get; set; }
    public DateTime DateTime { get; set; }
    public ICollection<GameResult> GameResults { get; set; }
}