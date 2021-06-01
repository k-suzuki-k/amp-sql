Set-PSDebug -Strict

$sql = "INSERT INTO T_FOO(a, b, c) VALUES('?', 'foo', ?) ;"
$parameters = @(120000, 250010)
$total_record = 10000

#################################################

function create-sql($sql, $parameters) {
    $regex = [regex]'\?'
    
    foreach ($p in $parameters) {
        $sql = $regex.Replace($sql, $p, 1)
    }

    return $sql
}

function inc-param($parameterts) {
    $end = $parameterts.count - 1
    
    foreach ($i in 0..$end) {
        $parameterts[$i]++
    }
}

#################################################

$sqls = New-Object System.Text.StringBuilder

foreach ($i in 0..$total_record) {

    $s = create-sql $sql $parameters
    
    $sqls.AppendLine($s) | Out-Null
    
    if ($i % 1000 -eq 0) {
        $sqls.ToString().TrimEnd()
        $sqls.Clear() | Out-Null
    }

    inc-param $parameters
}

$sqls.ToString().TrimEnd()
