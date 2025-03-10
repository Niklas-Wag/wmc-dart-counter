namespace DartDbLib;

public class Player
{
    public int Id { get; set; }
    public string Name { get; set; }
    public ICollection<GameResult> GameResults { get; set; }
}
