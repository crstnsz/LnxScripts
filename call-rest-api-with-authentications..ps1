$user = 'user'
$pass = 'password'

$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

Invoke-RestMethod -Uri "http://localhost:9200/my_document"  -Headers $Headers -Method Get -ContentType "application/json"