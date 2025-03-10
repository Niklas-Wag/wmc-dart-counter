namespace DartDbLib;

public class GameResult
{
    public int Id { get; set; }
    public bool IsWinner { get; set; }
    public int PlayerId { get; set; }
    public Player Player { get; set; }
    public int GameId { get; set; }
    public Game Game { get; set; }
}