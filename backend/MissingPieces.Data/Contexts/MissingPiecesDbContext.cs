using Microsoft.EntityFrameworkCore;
using MissingPieces.Models.Entities;

namespace MissingPieces.Data.Contexts;

public class MissingPiecesDbContext(DbContextOptions<MissingPiecesDbContext> options) : DbContext(options)
{
    public DbSet<ListedBuilding> ListedBuildings => Set<ListedBuilding>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ListedBuilding>(entity =>
        {
            entity.ToTable("listed_buildings");
            entity.HasKey(item => item.BuildingId);

            entity.Property(item => item.BuildingId).HasColumnName("building_id");
            entity.Property(item => item.Name).HasColumnName("name").HasMaxLength(500);
            entity.Property(item => item.Grade).HasColumnName("grade").HasMaxLength(10);
            entity.Property(item => item.LastPhotoUploadedDate).HasColumnName("last_photo_uploaded_date");
        });
    }
}
