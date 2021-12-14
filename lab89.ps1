#changelog
#Data utworzenia: 5.12.2021
#automatyzacja przetwarzania 


#---------------------------------------------------------------------------------------


$TIMESTAMP = Get-Date -Format MMddyyyy
$INDEXNUMBER = 400444
New-Item -Path 'C:\Users\acer\Desktop\lab89\PROCESSED' -ItemType Directory

#---------------------------------------------------------------------------------------
#popbranie plików
try{


$adres1 = "https://home.agh.edu.pl/~wsarlej/Customers_Nov2021.zip"
$zapisz_jako1 = "C:\Users\acer\Desktop\lab89\Customers_Nov2021.zip"
$adres2 = "https://home.agh.edu.pl/~wsarlej/Customers_old.csv"
$zapisz_jako2 = "C:\Users\acer\Desktop\lab89\Customers_old.csv"

$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($adres1,$zapisz_jako1)
$webclient = New-Object System.Net.WebClient
$webclient.DownloadFile($adres2,$zapisz_jako2)
 
Write-Output("$TIMESTAMP - pobranie plików -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - pobranie plików -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}

#-------------------------------------------------------------------------------------------
#rozpakowanie

try{

$7ZipPath = '"C:\Program Files\7-Zip\7z.exe"'
$zipFile = '"C:\Users\acer\Desktop\lab89\Customers_Nov2021.zip"'
$zipFilePassword = "agh"
$command = "& $7ZipPath e -oc:\\Users\acer\Desktop\lab89 -tzip -p$zipFilePassword $zipFile"

iex $command

Write-Output("$TIMESTAMP - rozpakowanie plików -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
Write-Output("$TIMESTAMP - rozpakowanie plików -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}


#--------------------------------------------------------------------------------------------------------------------------------
#różnica
#(Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.csv) | Where-Object {$_.trim() -ne '' } | Set-Content 'C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt'

try{
Compare-Object -ReferenceObject (Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.csv) -DifferenceObject (Get-Content C:\Users\acer\Desktop\lab89\Customers_old.csv) | where-object SideIndicator -eq "<=" | select inputobject > 'C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt'
(Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt) | Where-Object {$_.trim() -ne '' } | Set-Content 'C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt' 
Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt | Where-Object { -not $_.Contains('InputObject') }  > C:\Users\acer\Desktop\lab89\tmp.txt
Get-Content C:\Users\acer\Desktop\lab89\tmp.txt | Where-Object { -not $_.Contains('-----------') }| out-file C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt -Encoding utf8

#część wspólna plik błędny
Compare-Object -ReferenceObject (Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.csv) -IncludeEqual (Get-Content C:\Users\acer\Desktop\lab89\Customers_old.csv) | where-object SideIndicator -eq "=="| select inputobject  > C:\Users\acer\Desktop\lab89\Customers2021.bad_${TIMESTAMP}
Get-Content C:\Users\acer\Desktop\lab89\Customers2021.bad_${TIMESTAMP} | Where-Object { -not $_.Contains('InputObject') }  > 'C:\Users\acer\Desktop\lab89\tmp.txt'
Get-Content C:\Users\acer\Desktop\lab89\tmp.txt | Where-Object { -not $_.Contains('-----------') }  > C:\Users\acer\Desktop\lab89\Customers2021.bad_${TIMESTAMP} 

#Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt  | Out-File C:\Users\acer\Desktop\lab89\Customers_Nov2021.csv -Encoding utf8

Remove-Item -Path C:\Users\acer\Desktop\lab89\tmp.txt

Write-Output("$TIMESTAMP - poprawność pliku -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
Write-Output("$TIMESTAMP - poprawność pliku -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}



#-------------------------------------------------------------------------------------------------------------------------------------------------------------------
#instalacja psql
#Install-Module PostgreSQLCmdlets
#tworzenie tabeli
try{

$tablename = "customers_${INDEXNUMBER}";
$Database = "cw89"

$postgresql = Connect-PostgreSQL  -User "postgres" -Password "zagorzany1" -Database $Database -Server "127.0.0.1" -Port "5432"

 Invoke-PostgreSQL -Connection $postgresql -Query "Create table if not exists $tablename (first_name varchar(20), last_name varchar(20), email varchar(50), lat varchar(20), long varchar(20))" 

 Write-Output("$TIMESTAMP - tworzenie tabeli -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
   }
   catch
   {
   Write-Output("$TIMESTAMP - tworzenie tabeli -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
   }


#--------------------------------------------------------------------------------------------------------------------------------------------------------------------
#ładowanie danych 
try{

$Plik = Get-Content C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt
$Plik2 = $Plik -replace ",", "','"

    for($i=0; $i -lt $Plik.Count; $i++)
    {
        $Plik2[$i] = "'" + $Plik2[$i] + "'"
        $wczytaj = $Plik2[$i]

        Invoke-PostgreSQL -connection $postgresql -Query "INSERT INTO $tablename (first_name, last_name, email, lat, long) VALUES($wczytaj)"
    }
    Write-Output("$TIMESTAMP - wczytanie danych do tabeli -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }
    catch
    {
    Write-Output("$TIMESTAMP - wczytanie danych do tabeli -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }
  
   #psql -U postgres -d $NewDatabase -w -c "copy $tablename from 'C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt' delimiter ','"
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------
#tworzenie podkatalogu i przeniesienie pliku

try{

#New-Item -Path 'C:\Users\acer\Desktop\lab89\PROCESSED' -ItemType Directory
Copy-Item -Path C:\Users\acer\Desktop\lab89\Customers_Nov2021.txt -Destination C:\Users\acer\Desktop\lab89\Customers_Nov2021_v2.txt
Move-Item -Path C:\Users\acer\Desktop\lab89\Customers_Nov2021_v2.txt -Destination C:\Users\acer\Desktop\lab89\PROCESSED\Customers_${TIMESTAMP}_Nov2021.csv -PassThru

Write-Output("$TIMESTAMP - przeniesienie pliku -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
    Write-Output("$TIMESTAMP - przeniesienie pliku -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------
#wysyłanie emailu

try{

$lines1 = get-content C:\Users\acer\Desktop\lab89\Customers_Nov2021.csv |   Measure-Object -Line | Select-Object Lines #plik początkowy
$lines2 = get-content C:\Users\acer\Desktop\lab89\PROCESSED\Customers_${TIMESTAMP}_Nov2021.csv |  Measure-Object -Line #plik bez dubli
$lines3 = get-content C:\Users\acer\Desktop\lab89\Customers2021.bad_${TIMESTAMP} |  Measure-Object -Line #plik z dublami

$lines1 = $lines1.Lines
$lines2 = $lines2.Lines 
$lines3 = $lines3.Lines



$wiersze = Invoke-PostgreSQL -Connection $postgresql -Query "select count(*) from $tablename"  #rekordy w tabeli
$wiersze = $wiersze.count_42


$EmailFrom = "alert6492@gmail.com"
$EmailTo = "ewelinabrach452@gmail.com"
$Subject = "CUSTOMERS LOAD-${TIMESTAMP}"
$Body = "Liczba wierszy w pliku pobranym z internetu: $lines1 `nLiczba poprawnych wierszy (po czyszczeniu): $lines2 `nLiczba duplikatów w pliku wejściowym: $lines3 `nIlość danych załadowanych do tabeli $tablename : $wiersze."

$SMTPServer = "smtp.gmail.com"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential ("alert6492@gmail.com", "alertalert1")

$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)

Write-Output("$TIMESTAMP - wysłanie maila -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
Write-Output("$TIMESTAMP - wysłanie maila -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}



#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#zapytanie sql

    
   try{
   
 Set-Location 'C:\Program Files\PostgreSQL\13\bin\'

    $User = "postgres"
    $Password = "postgres"
    $env:PGPASSWORD = $Password
    $Database = "postgres"
    $NewDatabase = "cw89"
    $Serwer  ="PostgreSQL 13"
    $Port = "5432"
    $bestTabela = "best_customers_$INDEXNUMBER"
    
    psql -U postgres -d $NewDatabase -w -c "Create extension postgis"
    psql -U postgres -d $NewDatabase -w -f "C:\Users\acer\Desktop\lab89\zapytaniesql.txt"

 Write-Output("$TIMESTAMP - zapytanie sql -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
 }
 catch
 {
 Write-Output("$TIMESTAMP - zapytanie sql -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
 }

#-------------------------------------------------------------------------------------------------------------------------------------------------------------
 #eksport csv
 try{

    Invoke-PostgreSQL -Connection $postgresql -Query "SELECT * FROM $bestTabela" | Export-Csv "C:\Users\acer\Desktop\lab89\$bestTabela.csv"
    Write-Output("$TIMESTAMP - eksport csv -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }
    catch
    {
    Write-Output("$TIMESTAMP - eksport csv -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }

#----------------------------------------------------------------------------------------------------------------------------------------------------------------
#kompresja


try{
    Compress-Archive "C:\Users\acer\Desktop\lab89\$bestTabela.csv" -DestinationPath "C:\Users\acer\Desktop\lab89\$bestTabela.zip"
    Write-Output("$TIMESTAMP - kompresja -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }
    catch
    {
    Write-Output("$TIMESTAMP - kompresja -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
    }



#-----------------------------------------------------------------------------------------------------------------------------------------------------------------

#mail z załącznikiem

try{
$smtp = new-object Net.Mail.SmtpClient($SMTPServer,587)
$msg = new-object Net.Mail.MailMessage
$smtp.EnableSsl = $true
$smtp.Credentials =  New-Object System.Net.NetworkCredential ("alert6492@gmail.com", "alertalert1")
$file = "C:\Users\acer\Desktop\lab89\$bestTabela.zip"
$att = new-object Net.Mail.Attachment($file)

$msg.From = "alert6492@gmail.com"
$msg.To.Add("ewelinabrach452@gmail.com")
$msg.Subject = "CUSTOMERS_LOAD-${TIMESTAMP}"
$msg.Body = "Liczba wierszy w pliku pobranym z internetu: $lines1 `nLiczba poprawnych wierszy (po czyszczeniu): $lines2 `nLiczba duplikatów w pliku wejściowym: $lines3 `nIlość danych załadowanych do tabeli $tablename : $wiersze."
$msg.Attachments.Add($att)
$smtp.Send($msg)
Write-Output("$TIMESTAMP - mail z załącznikiem -> sukces") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}
catch
{
Write-Output("$TIMESTAMP - mail z załącznikiem -> błąd") >> C:\Users\acer\Desktop\lab89\PROCESSED\cw89_${TIMESTAMP}.log
}






