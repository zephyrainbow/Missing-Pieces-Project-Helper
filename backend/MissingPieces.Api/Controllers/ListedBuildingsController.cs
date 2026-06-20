using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MissingPieces.Data.Contexts;
using MissingPieces.Models.Entities;

namespace MissingPieces.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ListedBuildingsController(MissingPiecesDbContext dbContext) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<ListedBuilding>), StatusCodes.Status200OK)]
    public async Task<ActionResult<IEnumerable<ListedBuilding>>> GetAll(CancellationToken cancellationToken)
    {
        var items = await dbContext.ListedBuildings
            .AsNoTracking()
            .OrderBy(item => item.BuildingId)
            .Take(100)
            .ToListAsync(cancellationToken);

        return Ok(items);
    }
}
