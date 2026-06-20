namespace MissingPieces.Models.Entities;

public class ListedBuilding
{
    public long BuildingId { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Grade { get; set; } = string.Empty;

    public DateTimeOffset? LastPhotoUploadedDate { get; set; }
}
