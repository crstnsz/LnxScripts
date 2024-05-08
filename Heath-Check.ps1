$req = [system.Net.WebRequest]::Create("https://dsv.docspider.com.br/health")
$req.Timeout=5000
$res = $req.GetResponse()

 $int = [int]$res.StatusCode


 Write-Host $res.StatusCode