using DartDbLib;
using Microsoft.EntityFrameworkCore;

namespace DartAppBackend.Controllers;

[Route("api/[controller]")]
[ApiController]
public class GamesController(DartContext context) : ControllerBase
{

    [HttpGet("players-stats")]
    public async Task<ActionResult<IEnumerable<PlayerStatsDto>>> GetPlayerStats()
    {
        this.Log();
        var playerStats = await context.Players
            .Select(player => new PlayerStatsDto
            {
                PlayerId = player.Id,
                Name = player.Name,
                TotalGames = player.GameResults.Count(),
                Wins = player.GameResults.Count(gr => gr.IsWinner),
                WinRatio = player.GameResults.Count() > 0 ? (double)player.GameResults.Count(gr => gr.IsWinner) / player.GameResults.Count() : 0
            })
            .ToListAsync();
        
        return Ok(playerStats);
    }

    [HttpPost]
    public async Task<ActionResult<GameDto>> AddGameWithResults([FromBody] GameDto gameDto)
    {
        this.Log();
        var game = new Game { DateTime = DateTime.UtcNow, GameResults = new List<GameResult>() };
        
        foreach (var result in gameDto.Results)
        {
            var player = await context.Players.FindAsync(result.PlayerId);
            if (player == null)
            {
                return NotFound($"Player with ID {result.PlayerId} not found");
            }
            
            game.GameResults.Add(new GameResult { PlayerId = result.PlayerId, IsWinner = result.IsWinner });
        }
        
        context.Games.Add(game);
        await context.SaveChangesAsync();
        return Created();
    }
}