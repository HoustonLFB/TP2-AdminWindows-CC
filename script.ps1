Import-Module ActiveDirectory

$chemin = "CN=Computers,DC=lefebvre,DC=stri"

#prend tous les ordinateurs dans l'ou
$computers = Get-ADComputer -Filter * -SearchBase $chemin

foreach($computer in $computers) {
    #si le nom de l'ordinateur commence par F1, F2, F3
    if ($computer.Name -like "F*") {
        #Recuperation du la filale, du service et du type
        $filiale = $computer.Name.Split("-")[0]
        $service = $computer.Name.Split("-")[1]
        $type = $computer.Name.Split("-")[2]
        
        #Remplacement des abréviations par le nom complet de l'OU
        if ($service -eq "PR") {
            $service = "PRODUCT"
        }
        if ($service -eq "LO") {
            $service = "LOGISTIQUE"
        }
        if ($type -eq "PC") {
            $type = "Postes"
        }
        if ($type -eq "SRV") {
            $type = "Serveurs"
        }

        #Déplacement de l'ordinateur dans l'ou correspondante
        Move-ADObject -Identity $computer -TargetPath "OU=$($type),OU=$($service),OU=$($filiale),OU=LEFEBVRE,DC=lefebvre,DC=stri"
    }
}



