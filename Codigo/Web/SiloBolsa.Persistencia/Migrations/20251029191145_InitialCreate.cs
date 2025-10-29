using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace SiloBolsa.Persistencia.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterDatabase()
                .Annotation("Npgsql:PostgresExtension:uuid-ossp", ",,");

            migrationBuilder.CreateTable(
                name: "grano",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    descripcion = table.Column<string>(type: "text", nullable: true),
                    humedad_max = table.Column<double>(type: "double precision", nullable: false),
                    humedad_min = table.Column<double>(type: "double precision", nullable: false),
                    temp_max = table.Column<double>(type: "double precision", nullable: false),
                    temp_min = table.Column<double>(type: "double precision", nullable: false),
                    nivel_dioxido_max = table.Column<double>(type: "double precision", nullable: false),
                    nivel_dioxido_min = table.Column<double>(type: "double precision", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_grano", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "silo",
                columns: table => new
                {
                    id_silo = table.Column<Guid>(type: "uuid", nullable: false),
                    latitud = table.Column<double>(type: "double precision", nullable: false),
                    longitud = table.Column<double>(type: "double precision", nullable: false),
                    capacidad = table.Column<int>(type: "integer", nullable: false),
                    tipo_grano = table.Column<int>(type: "integer", nullable: false),
                    descripcion = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_silo", x => x.id_silo);
                    table.ForeignKey(
                        name: "FK_silo_grano_tipo_grano",
                        column: x => x.tipo_grano,
                        principalTable: "grano",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "alerta",
                columns: table => new
                {
                    id_alerta = table.Column<Guid>(type: "uuid", nullable: false),
                    fecha_ḧora_alerta = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    mensaje = table.Column<string>(type: "text", nullable: true),
                    id_silo = table.Column<Guid>(type: "uuid", nullable: false),
                    correoenviado = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_alerta", x => x.id_alerta);
                    table.ForeignKey(
                        name: "FK_alerta_silo_id_silo",
                        column: x => x.id_silo,
                        principalTable: "silo",
                        principalColumn: "id_silo",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "caja",
                columns: table => new
                {
                    id_caja = table.Column<Guid>(type: "uuid", nullable: false),
                    ubicacion_en_silo = table.Column<int>(type: "integer", nullable: false),
                    id_silo = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_caja", x => x.id_caja);
                    table.ForeignKey(
                        name: "FK_caja_silo_id_silo",
                        column: x => x.id_silo,
                        principalTable: "silo",
                        principalColumn: "id_silo",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "lectura",
                columns: table => new
                {
                    id_lectura = table.Column<Guid>(type: "uuid", nullable: false),
                    fecha_hora_lectura = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    temp = table.Column<double>(type: "double precision", nullable: false),
                    humedad = table.Column<double>(type: "double precision", nullable: false),
                    dioxido_de_carbono = table.Column<double>(type: "double precision", nullable: false),
                    id_caja = table.Column<Guid>(type: "uuid", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_lectura", x => x.id_lectura);
                    table.ForeignKey(
                        name: "FK_lectura_caja_id_caja",
                        column: x => x.id_caja,
                        principalTable: "caja",
                        principalColumn: "id_caja",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_alerta_fecha_ḧora_alerta",
                table: "alerta",
                column: "fecha_ḧora_alerta");

            migrationBuilder.CreateIndex(
                name: "IX_alerta_id_silo",
                table: "alerta",
                column: "id_silo");

            migrationBuilder.CreateIndex(
                name: "IX_caja_id_silo",
                table: "caja",
                column: "id_silo");

            migrationBuilder.CreateIndex(
                name: "IX_lectura_fecha_hora_lectura",
                table: "lectura",
                column: "fecha_hora_lectura");

            migrationBuilder.CreateIndex(
                name: "IX_lectura_id_caja",
                table: "lectura",
                column: "id_caja");

            migrationBuilder.CreateIndex(
                name: "IX_silo_tipo_grano",
                table: "silo",
                column: "tipo_grano");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "alerta");

            migrationBuilder.DropTable(
                name: "lectura");

            migrationBuilder.DropTable(
                name: "caja");

            migrationBuilder.DropTable(
                name: "silo");

            migrationBuilder.DropTable(
                name: "grano");
        }
    }
}
