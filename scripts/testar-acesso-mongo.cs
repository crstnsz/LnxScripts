#:package MongoDB.Driver@2.14.1

using MongoDB.Bson;
using MongoDB.Driver;

await MainAsync();

static async Task MainAsync()
{
    try
    {
        var client = new MongoClient("mongodb://192.168.0.67:27017");
        var database = client.GetDatabase("admin");
        var comando = new BsonDocument("ping", 1);
        var resultado = await database.RunCommandAsync<BsonDocument>(comando);
        
        Console.WriteLine(resultado["ok"].AsInt32 == 1 
            ? "✅ MongoDB disponível!" 
            : "❌ Ping falhou");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"❌ Erro: {ex.Message}");
    }
}
