using Microsoft.EntityFrameworkCore;
using DartDbLib;

namespace DartAppBackend.Controllers;

[Route("api/[controller]")]
[ApiController]
public class PlayersController(DartContext context) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IEnumerable<PlayerDto>>> GetPlayers()
    {
        this.Log();
        var players = await context.Players
            .OrderByDescending(x => x.GameResults.Count)
            .Select(p => new PlayerDto { Id = p.Id, Name = p.Name })
            .ToListAsync();
        return Ok(players);
    }

    [HttpPost]
    public async Task<ActionResult<PlayerDto>> AddPlayer(string name)
    {
        this.Log();
        var player = new Player { Name = name };
        context.Players.Add(player);
        await context.SaveChangesAsync();
        return Created();
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> DeletePlayer(int id)
    {
        this.Log();
        var player = await context.Players.FindAsync(id);
        if (player == null)
        {
            return NotFound();
        }

        context.Players.Remove(player);
        await context.SaveChangesAsync();
        return NoContent();
    }
}